#Requires AutoHotkey v2.0
#SingleInstance Force
Persistent

global currentInputMode := ""

; Tray setup
A_IconTip := "Case Mode: None"
TraySetIcon("Shell32.dll", 44)
TraySetToolTip("Case Mode: None")
MenuExit := Menu()
MenuExit.Add("Exit Script", (*) => ExitApp())
A_TrayMenu := MenuExit

; ===== INPUT MODE SETTERS (CapsLock + key) =====
Hotkey("CapsLock & .", (*) => SetInputCase("sentence"))
Hotkey("CapsLock & l", (*) => SetInputCase("lower"))
Hotkey("CapsLock & u", (*) => SetInputCase("upper"))
Hotkey("CapsLock", (*) => SetInputCase("caps"))
Hotkey("CapsLock & a", (*) => SetInputCase("alt"))
Hotkey("CapsLock & t", (*) => SetInputCase("title"))
Hotkey("CapsLock & p", (*) => SetInputCase("pascal"))
Hotkey("CapsLock & c", (*) => SetInputCase("camel"))
Hotkey("CapsLock & m", (*) => SetInputCase("camel"))
Hotkey("CapsLock & s", (*) => SetInputCase("snake"))
Hotkey("CapsLock & _", (*) => SetInputCase("snake"))
Hotkey("CapsLock & k", (*) => SetInputCase("kebab"))
Hotkey("CapsLock & -", (*) => SetInputCase("kebab"))
Hotkey("CapsLock & Alt", (*) => SetInputCase("invert"))

; ===== TEXT TRANSFORMS (Ctrl + CapsLock + key) =====
Hotkey("^CapsLock & .", (*) => FormatClipboard("sentence"))
Hotkey("^CapsLock & l", (*) => FormatClipboard("lower"))
Hotkey("^CapsLock & u", (*) => FormatClipboard("upper"))
Hotkey("^CapsLock", (*) => SetInputCase("caps"))
Hotkey("^CapsLock & a", (*) => FormatClipboard("alt"))
Hotkey("^CapsLock & t", (*) => FormatClipboard("title"))
Hotkey("^CapsLock & p", (*) => FormatClipboard("pascal"))
Hotkey("^CapsLock & c", (*) => FormatClipboard("camel"))
Hotkey("^CapsLock & m", (*) => FormatClipboard("camel"))
Hotkey("^CapsLock & s", (*) => FormatClipboard("snake"))
Hotkey("^CapsLock & _", (*) => FormatClipboard("snake"))
Hotkey("^CapsLock & k", (*) => FormatClipboard("kebab"))
Hotkey("^CapsLock & -", (*) => FormatClipboard("kebab"))
Hotkey("^CapsLock & Alt", (*) => FormatClipboard("invert"))

; ===== SET INPUT MODE =====
SetInputCase(mode) {
    global currentInputMode := mode
    TrayTip("Case Mode Set", "Typing will now be in " mode " case.", 1000)
    A_IconTip := "Case Mode: " mode
    TraySetToolTip(A_IconTip)
}

; ===== FORMAT CLIPBOARD SELECTION =====
FormatClipboard(mode) {
    A_Clipboard := ""
    Send("^c")
    if !ClipWait(0.3)
        Send("^a^c"), ClipWait(0.3)
    
    text := A_Clipboard
    if text = ""
        return

    switch mode {
        case "lower": newText := StrLower(text)
        case "upper": newText := StrUpper(text)
        case "caps": newText := RegExReplace(text, "\b\w", "$u0")
        case "sentence": newText := FormatSentence(text)
        case "alt": newText := FormatAlt(text)
        case "title": newText := FormatTitle(text)
        case "invert": newText := FormatInvert(text)
        case "pascal": newText := FormatPascal(text)
        case "camel": newText := FormatCamel(text)
        case "snake": newText := FormatSnake(text)
        case "kebab": newText := FormatKebab(text)
        default: return
    }

    A_Clipboard := newText
    Sleep(100)
    Send("^v")
}

; ===== CASE TRANSFORMATION FUNCTIONS =====
FormatSentence(text) {
    text := Trim(text)
    return RegExReplace(text, "([.?!]\s*|^)([a-z])", "$1" Chr(Asc(SubStr("$2", 1)) - 32))
}

FormatAlt(text) {
    out := ""
    toggle := true
    Loop Parse text {
        char := A_LoopField
        if RegExMatch(char, "[a-zA-Z]") {
            out .= toggle ? StrUpper(char) : StrLower(char)
            toggle := !toggle
        } else {
            out .= char
        }
    }
    return out
}

FormatTitle(text) {
    return RegExReplace(text, "\b\w+", "$u0")
}

FormatInvert(text) {
    out := ""
    Loop Parse text {
        char := A_LoopField
        if char ~= "[A-Z]"
            out .= StrLower(char)
        else if char ~= "[a-z]"
            out .= StrUpper(char)
        else
            out .= char
    }
    return out
}

FormatPascal(text) {
    return RegExReplace(StrLower(text), "(?:^|\s|_|-)(\w)", "$u1")
}

FormatCamel(text) {
    result := FormatPascal(text)
    return StrLower(SubStr(result, 1, 1)) . SubStr(result, 2)
}

FormatSnake(text) {
    text := RegExReplace(text, "[^\w\s]", "")
    return RegExReplace(StrLower(text), "\s+", "_")
}

FormatKebab(text) {
    text := RegExReplace(text, "[^\w\s]", "")
    return RegExReplace(StrLower(text), "\s+", "-")
}
