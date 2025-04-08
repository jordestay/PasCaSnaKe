#Requires AutoHotkey v2.0
#SingleInstance Force
Persistent

; Hotkeys
Hotkey("CapsLock & l", (*) => TransformSelected("lower"))
Hotkey("CapsLock & u", (*) => TransformSelected("upper"))

TransformSelected(mode) {
    A_Clipboard := ""
    Send("^c")
    if !ClipWait(0.3)
        return

    text := A_Clipboard
    if (text = "")
        return

    if mode = "lower"
        text := StrLower(text)
    else if mode = "upper"
        text := StrUpper(text)

    A_Clipboard := text
    Sleep(100)
    Send("^v")
}
