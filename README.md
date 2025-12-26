# Peekaboo 🙈

A lightweight macOS menu bar app to quickly hide/show desktop icons and windows with a single click or keyboard shortcut.

![macOS](https://img.shields.io/badge/macOS-11.0+-black?style=flat-square&logo=apple)
![License](https://img.shields.io/badge/license-MIT-blue?style=flat-square)

## Features

- **One-click toggle** — Click the menu bar icon to instantly hide/show your desktop
- **Global hotkey** — Use `⌘⇧D` (customizable) from anywhere
- **Hides everything** — Desktop icons AND application windows
- **Visual feedback** — HUD overlay shows current state
- **Auto-updates** — Built-in Sparkle updater keeps you current
- **Launch at login** — Start automatically with your Mac

## Installation

Download the latest `.dmg` from [Releases](https://github.com/idnan/peekaboo/releases), open it, and drag Peekaboo to Applications.

## Usage

| Action | How |
|--------|-----|
| Toggle desktop | Click 🐵 in menu bar |
| Toggle desktop | Press `⌘⇧D` (default) |
| Open menu | Right-click menu bar icon |
| Preferences | Right-click → Preferences |
| Check for updates | Right-click → Check for Updates |

### Menu Bar Icons

- 🐵 — Desktop visible
- 🙈 — Desktop hidden

## Permissions

Peekaboo needs these permissions to work:

| Permission | Why |
|------------|-----|
| Accessibility | To register global keyboard shortcuts |
| Automation | To minimize/restore application windows |

Grant these in **System Settings → Privacy & Security**.

## Building from Source

### Requirements

- macOS 11.0+
- Xcode 15+

### Build

```bash
git clone https://github.com/idnan/peekaboo.git
cd peekaboo
open Peekaboo.xcodeproj
```

Then build with `⌘B` or Product → Build.

### Dependencies

- [Sparkle](https://sparkle-project.org/) — Auto-updates (added via Swift Package Manager)

## Contributing

Pull requests welcome! For major changes, please open an issue first.

## License

[MIT](LICENSE)

---

Made with ☕ by [Adnan Ahmed](https://github.com/idnan)

