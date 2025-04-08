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
CapsLock & "."::SetInputCase("sentence")
CapsLock & "l"::SetInputCase("lower")
CapsLock & "u"::SetInputCase("upper")
CapsLock::SetInputCase("caps")
CapsLock & "a"::SetInputCase("alt")
CapsLock & "t"::SetInputCase("title")
CapsLock & "p"::SetInputCase("pascal")
CapsLock & "c"::SetInputCase("camel")
CapsLock & "m"::SetInputCase("camel")
CapsLock & "s"::SetInputCase("snake")
CapsLock & "_"::SetInputCase("snake")
CapsLock & "k"::SetInputCase("kebab")
CapsLock & "-"::SetInputCase("kebab")
CapsLock & "Alt"::SetInputCase("invert")

; ===== TEXT TRANSFORMS (Ctrl + CapsLock + key) =====
^CapsLock & "."::FormatClipboard("sentence")
^CapsLock & "l"::FormatClipboard("lower")
^CapsLock & "u"::FormatClipboard("upper")
^CapsLock::SetInputCase("caps")
^CapsLock & "a"::FormatClipboard("alt")
^CapsLock & "t"::FormatClipboard("title")
^CapsLock & "p"::FormatClipboard("pascal")
^CapsLock & "c"::FormatClipboard("camel")
^CapsLock & "m"::FormatClipboard("camel")
^CapsLock & "s"::FormatClipboard("snake")
^CapsLock & "_"::FormatClipboard("snake")
^CapsLock & "k"::FormatClipboard("kebab")
^CapsLock & "-"::FormatClipboard("kebab")
^CapsLock & "Alt"::FormatClipboard("invert")

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
