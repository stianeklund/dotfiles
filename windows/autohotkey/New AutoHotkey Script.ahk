; IMPORTANT INFO ABOUT GETTING STARTED: Lines that start with a
; semicolon, such as this one, are comments.  They are not executed.

; This script has a special filename and path because it is automatically
; launched when you run the program directly.  Also, any text file whose
; name ends in .ahk is associated with the program, which means that it
; can be launched simply by double-clicking it.  You can have as many .ahk
; files as you want, located in any folder.  You can also run more than
; one .ahk file simultaneously and each will get its own tray icon.

; Always reload script, skip message box
#SingleInstance force

GroupAdd, ConsoleWindowGroup, ahk_class ConsoleWindowClass
GroupAdd, ConsoleWindowGroup, ahk_class mintty

#IfWinActive ahk_class ConsoleWindowClass
; Paste in command window
^V::
Send !{Space}ep
return

#IfWinActive
RAlt & x::Send !{f4}
Return

#IfWinActive
RAlt & m::WinMinimize, A
Return

; Msys2
#IfWinActive ahk_class mintty
    ; Paste in command window
    ^v::
    Send +{Ins}
    return

#if (!WinActive("ahk_class mintty"))
^W::Send,+{Ctrl}{Backspace} ;;Delete previous word
Return

#if (!WinActive("ahk_class mintty"))
RAlt & t::AltTab

#if (!WinActive("ahk_class mintty"))
RAlt & s::ShiftAltTab

#if (!WinActive("ahk_class mintty"))
^U::   ;;erase to start of line
Send {LShift down}{Home}{LShift Up}{Del}
Return

#if (!WinActive("ahk_class mintty"))
^A::   ;;move to start of line
Send {Home}
Return

#if (!WinActive("ahk_class mintty"))
^E::   ;;move to end of line
Send {End}
Return

#if (!WinActive("ahk_class mintty"))
^F::   ;; move one char forward
Send {Right}
Return
#if (!WinActive("ahk_class mintty"))
^B::   ;;move one char back
Send {Left}
Return

#IfWinActive
; Ctrl+up / Down to scroll command window back and forward
    ^Up::
    Send {WheelUp}
    return

    ^Down::
    Send {WheelDown}
    return
#IfWinActive

SetToolTip(msg)
{
    #Persistent
    ToolTip, %msg%
    SetTimer, RemoveToolTip, 300
}

RemoveToolTip:
{
    SetTimer, RemoveToolTip, Off
    ToolTip
}

SetKeyboardLayer(layer)
{
    global keyboardLayer
    keyboardLayer := layer
    if (layer = 0)
    {
        SetToolTip("Standard keyboard layer")
    }
    else SetToolTip("Unknown layer")
    }

