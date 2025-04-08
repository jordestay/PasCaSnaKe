#SingleInstance Force
#Persistent
#NoEnv

; Define input modes
global caseModes := ["sentence", "lower", "upper", "caps", "alt", "title", "invert"]
global currentInputMode := ""

; Set tray icon and tooltip
Menu, Tray, Icon, Shell32.dll, 44 ; Change icon as desired
Menu, Tray, Tip, Case Mode: None
Menu, Tray, NoStandard
Menu, Tray, Add, Exit Script, ExitApp

; ==============================
; Input Mode Setters
; ==============================
(* CapsLock & s::SetInputCase("sentence") *)
CapsLock & .::SetInputCase("sentence")  ; period key
CapsLock & l::SetInputCase("lower")
CapsLock & u::SetInputCase("upper")
(* CapsLock & c::SetInputCase("caps") *)
CapsLock::SetInputCase("caps")  ; normal behavior w/o AHK
CapsLock & a::SetInputCase("alt")
CapsLock & t::SetInputCase("title")
CapsLock & Alt::SetInputCase("invert") ; AlTernAtINg binding
CapsLock & p::SetInputCase("pascal")
CapsLock & c::SetInputCase("camel")
CapsLock & m::SetInputCase("camel")
(* CapsLock & n::SetInputCase("snake") *)
CapsLock & s::SetInputCase("snake")
CapsLock & _::SetInputCase("snake")  ; underscore key
CapsLock & k::SetInputCase("kebab")
CapsLock & -::SetInputCase("kebab")  ; hyphen key

; ==============================
; Text Transformation (Ctrl + CapsLock + key)
; ==============================
(* ^CapsLock & s::FormatClipboard("sentence") *)
^CapsLock & .::SetInputCase("sentence")  ; period key
^CapsLock & l::FormatClipboard("lower")
^CapsLock & u::FormatClipboard("upper")
(* ^CapsLock & c::FormatClipboard("caps") *)
^CapsLock::SetInputCase("caps")
^CapsLock & a::FormatClipboard("alt")
^CapsLock & t::FormatClipboard("title")
^CapsLock & Alt::FormatClipboard("invert")
^CapsLock & p::FormatClipboard("pascal")
^CapsLock & c::SetInputCase("camel")
^CapsLock & m::FormatClipboard("camel")
(* ^CapsLock & n::FormatClipboard("snake") *)
^CapsLock & s::SetInputCase("snake")
^CapsLock & _::SetInputCase("snake")  ; underscore key
^CapsLock & k::FormatClipboard("kebab")
^CapsLock & -::SetInputCase("kebab")  ; hyphen key

; ==============================
; Functions
; ==============================

SetInputCase(mode) {
    global currentInputMode := mode
    TrayTip, Case Mode Set, Typing will now be in %mode% case., 1
    Menu, Tray, Tip, Case Mode: %mode%
}

FormatClipboard(mode) {
    Clipboard := ""
    Send ^c
    ClipWait, 0.3

    if (Clipboard = "") {
        Send ^a
        Sleep 100
        Send ^c
        ClipWait, 0.3
    }

    text := Clipboard
    if (text = "")
        return

    if (mode = "lower")
        newText := StrLower(text)
    else if (mode = "upper")
        newText := StrUpper(text)
    else if (mode = "caps")
        newText := RegExReplace(text, "\b\w", "$u0")
    else if (mode = "sentence")
        newText := FormatSentence(text)
    else if (mode = "alt")
        newText := FormatAlt(text)
    else if (mode = "title")
        newText := FormatTitle(text)
    else if (mode = "invert")
        newText := FormatInvert(text)
    else if (mode = "pascal")
        newText := FormatPascal(text)
    else if (mode = "camel")
        newText := FormatCamel(text)
    else if (mode = "snake")
        newText := FormatSnake(text)
    else if (mode = "kebab")
        newText := FormatKebab(text)
    else
        return

    Clipboard := newText
    Sleep 100
    Send ^v
}

FormatSentence(text) {
    text := Trim(text)
    return RegExReplace(text, "([.?!]\s*|^)([a-z])", "$1" . Chr(Asc("$2") - 32))
}

FormatAlt(text) {
    out := ""
    toggle := true
    Loop, Parse, text
    {
        char := A_LoopField
        if (RegExMatch(char, "[a-zA-Z]")) {
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
    Loop, Parse, text
    {
        char := A_LoopField
        if (char ~= "[A-Z]")
            out .= StrLower(char)
        else if (char ~= "[a-z]")
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
    text := RegExReplace(text, "[^\w\s]", "") ; Remove punctuation
    return RegExReplace(StrLower(text), "\s+", "_")
}

FormatKebab(text) {
    text := RegExReplace(text, "[^\w\s]", "")
    return RegExReplace(StrLower(text), "\s+", "-")
}

