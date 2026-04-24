#!/usr/bin/env bash
# Claude Code statusline — merged from existing + ClaudeCodeStatusLine by daniel3303

set -f  # disable globbing

input=$(timeout 2s cat 2>/dev/null)

if [ -z "$input" ]; then
    printf "Claude"
    exit 0
fi

if ! command -v jq >/dev/null 2>&1; then
    printf "jq not found"
    exit 0
fi

# ===== Colors =====
cyan='\033[36m'
purple='\033[35m'
blue='\033[38;2;0;153;255m'
orange='\033[38;2;255;176;85m'
green='\033[38;2;0;160;0m'
red='\033[38;2;255;85;85m'
yellow='\033[38;2;230;200;0m'
white='\033[38;2;220;220;220m'
dim='\033[2m'
muted='\033[38;2;130;140;160m'
reset='\033[0m'

format_tokens() {
    local num=$1
    if [ "$num" -ge 1000000 ]; then
        awk "BEGIN {printf \"%.1fm\", $num / 1000000}"
    elif [ "$num" -ge 1000 ]; then
        awk "BEGIN {printf \"%.0fk\", $num / 1000}"
    else
        printf "%d" "$num"
    fi
}

usage_color() {
    local pct=$1
    if [ "$pct" -ge 90 ]; then echo "$red"
    elif [ "$pct" -ge 70 ]; then echo "$orange"
    elif [ "$pct" -ge 50 ]; then echo "$yellow"
    else echo "$green"
    fi
}

# ===== Parse JSON =====
model_name=$(echo "$input" | jq -r '.model.display_name // "Claude"' 2>/dev/null)

# Current dir: try .cwd then .workspace.current_dir then fallback to pwd
current_dir=$(echo "$input" | jq -r '.cwd // .workspace.current_dir // ""' 2>/dev/null)
[ -z "$current_dir" ] && current_dir=$(pwd)

dir_name=$(basename "$current_dir")

# Git branch
git_branch=""
if command -v git >/dev/null 2>&1; then
    branch=$(git -C "$current_dir" rev-parse --abbrev-ref HEAD 2>/dev/null)
    [ -n "$branch" ] && git_branch=" on $branch"
fi

# Diff stats
git_stat=""
if [ -n "$git_branch" ]; then
    git_stat=$(git -C "$current_dir" diff --numstat 2>/dev/null | awk '{a+=$1; d+=$2} END {if (a+d>0) printf " +%d -%d", a, d}')
fi

# Token usage
size=$(echo "$input" | jq -r '.context_window.context_window_size // 200000' 2>/dev/null)
[ "$size" -eq 0 ] 2>/dev/null && size=200000
input_tokens=$(echo "$input" | jq -r '.context_window.current_usage.input_tokens // 0' 2>/dev/null)
cache_create=$(echo "$input" | jq -r '.context_window.current_usage.cache_creation_input_tokens // 0' 2>/dev/null)
cache_read=$(echo "$input" | jq -r '.context_window.current_usage.cache_read_input_tokens // 0' 2>/dev/null)
current=$(( input_tokens + cache_create + cache_read ))

# Fallback to used_percentage if no token counts
if [ "$current" -eq 0 ]; then
    used_percent=$(echo "$input" | jq -r '.context_window.used_percentage // 0' 2>/dev/null)
    pct_used=$(printf "%.0f" "$used_percent")
    used_tokens=""
    total_tokens=""
else
    used_tokens=$(format_tokens $current)
    total_tokens=$(format_tokens $size)
    pct_used=$(( size > 0 ? current * 100 / size : 0 ))
fi

# Effort level
effort_level="high"
if [ -n "$CLAUDE_CODE_EFFORT_LEVEL" ]; then
    effort_level="$CLAUDE_CODE_EFFORT_LEVEL"
elif [ -f "$HOME/.claude/settings.json" ]; then
    effort_val=$(jq -r '.effortLevel // empty' "$HOME/.claude/settings.json" 2>/dev/null)
    [ -n "$effort_val" ] && effort_level="$effort_val"
fi

# ===== Build output =====
sep=" ${muted}|${reset} "

out="${cyan}${dir_name}${reset}${purple}${git_branch}${reset}"
[ -n "$git_stat" ] && out+="${dim}${git_stat}${reset}"
out+="${sep}${blue}${model_name}${reset}"

# Tokens
tok_color=$(usage_color $pct_used)
if [ -n "$used_tokens" ]; then
    out+="${sep}${orange}${used_tokens}/${total_tokens}${reset} ${dim}(${reset}${tok_color}${pct_used}%${reset}${dim})${reset}"
else
    out+="${sep}${tok_color}${pct_used}%${reset}"
fi

# Effort
case "$effort_level" in
    low)    out+="${sep}${dim}low${reset}" ;;
    medium) out+="${sep}${orange}med${reset}" ;;
    *)      out+="${sep}${green}high${reset}" ;;
esac

# ===== OAuth token =====
get_oauth_token() {
    [ -n "$CLAUDE_CODE_OAUTH_TOKEN" ] && { echo "$CLAUDE_CODE_OAUTH_TOKEN"; return; }
    local creds_file="$HOME/.claude/.credentials.json"
    if [ -f "$creds_file" ]; then
        jq -r '.claudeAiOauth.accessToken // empty' "$creds_file" 2>/dev/null
    fi
}

# ===== Rate limit usage (cached 60s) =====
cache_file="/tmp/claude/statusline-usage-cache.json"
cache_max_age=60
mkdir -p /tmp/claude

needs_refresh=true
usage_data=""

if [ -f "$cache_file" ]; then
    cache_mtime=$(stat -c %Y "$cache_file" 2>/dev/null)
    now=$(date +%s)
    cache_age=$(( now - cache_mtime ))
    [ "$cache_age" -lt "$cache_max_age" ] && needs_refresh=false && usage_data=$(cat "$cache_file" 2>/dev/null)
fi

if $needs_refresh; then
    token=$(get_oauth_token)
    if [ -n "$token" ] && [ "$token" != "null" ]; then
        response=$(curl -s --max-time 8 \
            -H "Accept: application/json" \
            -H "Content-Type: application/json" \
            -H "Authorization: Bearer $token" \
            -H "anthropic-beta: oauth-2025-04-20" \
            -H "User-Agent: claude-code/2.1.34" \
            "https://api.anthropic.com/api/oauth/usage" 2>/dev/null)
        if [ -n "$response" ] && echo "$response" | jq . >/dev/null 2>&1; then
            usage_data="$response"
            echo "$response" > "$cache_file"
        fi
    fi
    [ -z "$usage_data" ] && [ -f "$cache_file" ] && usage_data=$(cat "$cache_file" 2>/dev/null)
fi

format_reset_time() {
    local iso_str="$1" style="$2"
    [ -z "$iso_str" ] || [ "$iso_str" = "null" ] && return
    local epoch
    epoch=$(date -d "$iso_str" +%s 2>/dev/null)
    [ -z "$epoch" ] && return
    case "$style" in
        time)     date -d "@$epoch" +"%-I:%M%P" ;;
        datetime) date -d "@$epoch" +"%-d %b %-I:%M%P" ;;
    esac
}

if [ -n "$usage_data" ] && echo "$usage_data" | jq -e . >/dev/null 2>&1; then
    five_pct=$(echo "$usage_data" | jq -r '.five_hour.utilization // 0' | awk '{printf "%.0f", $1}')
    five_reset=$(format_reset_time "$(echo "$usage_data" | jq -r '.five_hour.resets_at // empty')" "time")
    five_color=$(usage_color "$five_pct")
    out+="${sep}${white}5h${reset} ${five_color}${five_pct}%${reset}"
    [ -n "$five_reset" ] && out+=" ${muted}@${five_reset}${reset}"

    seven_pct=$(echo "$usage_data" | jq -r '.seven_day.utilization // 0' | awk '{printf "%.0f", $1}')
    seven_reset=$(format_reset_time "$(echo "$usage_data" | jq -r '.seven_day.resets_at // empty')" "datetime")
    seven_color=$(usage_color "$seven_pct")
    out+="${sep}${white}7d${reset} ${seven_color}${seven_pct}%${reset}"
    [ -n "$seven_reset" ] && out+=" ${muted}@${seven_reset}${reset}"

    extra_enabled=$(echo "$usage_data" | jq -r '.extra_usage.is_enabled // false')
    if [ "$extra_enabled" = "true" ]; then
        extra_pct=$(echo "$usage_data" | jq -r '.extra_usage.utilization // 0' | awk '{printf "%.0f", $1}')
        extra_used=$(echo "$usage_data" | jq -r '.extra_usage.used_credits // 0' | LC_NUMERIC=C awk '{printf "%.2f", $1/100}')
        extra_limit=$(echo "$usage_data" | jq -r '.extra_usage.monthly_limit // 0' | LC_NUMERIC=C awk '{printf "%.2f", $1/100}')
        extra_color=$(usage_color "$extra_pct")
        out+="${sep}${white}extra${reset} ${extra_color}\$${extra_used}/\$${extra_limit}${reset}"
    fi
fi

printf "%b" "$out"
