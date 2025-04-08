# 🐍 PasCaSnaKe (PCSK)

**A cross-platform keyboard utility for transforming and controlling text casing with style.**

Built for writers, developers, power users, and anyone who wants to type faster, cleaner, and with better control over text formatting.

---

## 📛 Name Origin

**PasCaSnaKe** = Pascal + Camel + Snake + Kebab = All your favorite dev case modes in one 🧠

---

## 🎯 Project Goal

Enable users to control casing behavior system-wide with smart keyboard shortcuts. Set typing modes (like camelCase or Sentence case), and apply transformations to selected text instantly. Think: `CapsLock + S` for Sentence case or `Ctrl + CapsLock + A` to aLtErNaTe the selected text.

---

## 🚧 Roadmap

### ✅ Stage 1: AutoHotkey MVP (Windows only)

- CapsLock + modifier to set input mode  
- CapsLock + Ctrl + modifier to transform selected text  
- Tooltip tray icon to indicate current input mode  
- Real-time typing transformation with AHK InputHook (planned)  
- Optional GUI to configure keybindings, behavior, and live preview  

### 🔄 Stage 2: Native Windows App (C#, Rust, or C++)

- Global keyboard hook  
- System tray app with real-time mode indicator  
- Clipboard + selection-aware case transformer  
- Configurable GUI  
- Windows installer or portable `.exe`  

### 🌐 Stage 3: Cross-Platform App (Tauri, Qt, or Electron)

- Cross-platform keyboard hooks (Win, macOS, Linux)  
- Unified input transformer module  
- Customizable GUI with theme support  
- Case profiles (e.g. "developer mode" with camel + snake)  
- App packaging for all OSs  

---

## 🧩 Planned Case Modes

- Sentence case → `This is a sentence.`
- lowercase → `this is lowercase.`
- UPPERCASE → `THIS IS UPPERCASE.`
- Capitalized Words → `Capitalized Words`
- aLtErNaTiNg CaSe → `AlTeRnAtInG CaSe`
- Title Case → `The Quick Brown Fox`
- Inverted CASE → `iNVERTED case`
- **camelCase** → `thisIsCamelCase`
- **PascalCase** → `ThisIsPascalCase`
- **snake_case** → `this_is_snake_case`
- **kebab-case** → `this-is-kebab-case`

---

## 🗂 GitHub Project Structure (Proposed)
```
PasCaSnaKe/
├── ahk/
│   └── pascasnake.ahk         # AHK MVP script
├── native/
│   ├── win/                   # Native Windows app (C#/C++/Rust)
│   └── shared/                # Case transformation core logic (reusable)
├── crossplatform/
│   └── tauri/                 # Tauri implementation for Win/macOS/Linux
├── icons/                    # Tray icons or emoji flags
├── docs/                     # Screenshots, how-to guides, specs
├── LICENSE
├── README.md
└── .gitignore
```

---

## ✅ Tasks

### Stage 1: AutoHotkey MVP

- [x] CapsLock + modifier → transform selected text
   - [ ] Re-highlight after transform (partial, per app)
- [ ] (KEY) + CapsLock + modifier → set mode  
- [ ] Switch input mode placeholder (to prep for InputHook)
- [ ] Real-time typing mode (InputHook)
- [ ] Experimental live input casing via InputHook (Pascal/camel/snake/kebab)
- [ ] Add tray tooltip support
- [ ] Custom icon + menu options  
- [ ] Packaged `.exe` version  

### Stage 2: Native Windows App

- [ ] Design system tray GUI  
- [ ] Build global hotkey listener  
- [ ] Clipboard-aware transformer  
- [ ] Settings/config JSON  
- [ ] Switchable icon display per mode  

### Stage 3: Cross-Platform

- [ ] Evaluate tech stack: Tauri vs Electron vs Qt  
- [ ] Build cross-platform hotkey handler  
- [ ] UI with settings sync  
- [ ] Keyboard input interception on macOS/Linux  
- [ ] Publish via Homebrew, Snapcraft, Windows Store  

---

## 💡 Want to contribute?

PRs and feedback are welcome! Especially help with:

- Better InputHook AHK examples  
- Windows native code structure  
- Cross-platform keyboard interception  
