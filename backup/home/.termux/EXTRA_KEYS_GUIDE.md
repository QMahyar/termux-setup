# Termux Extra Keys — Complete Reference

## Your Current Layout (2 rows, 9 keys each)

```
Row 1: ESC  TAB  ⌫BKSP  ⌦DEL  ⇱HOME  ↑  ⇲END  ⇑PGUP  ⇓PGDN
Row 2: CTRL  ALT  SHIFT  ⌨KBD  ←  ↓  →  SPACE  ↲ENTER
```

## How Special Modifier Buttons Work

| Button | Tap | Long-press |
|--------|-----|------------|
| CTRL | Activates for next keypress | Locks on (stays active) |
| ALT | Activates for next keypress | Locks on (stays active) |
| SHIFT | Activates for next keypress | Locks on (stays active) |
| FN | Activates for next keypress | Locks on (stays active) |

Tap the same button again to deactivate. Each special button can appear **ONLY ONCE** in the layout.

## Action Keys

| Key | What it does |
|-----|-------------|
| KEYBOARD (⌨) | Toggles soft keyboard on/off (configured as `enable/disable`) |
| DRAWER (☰) | Opens/closes the Termux navigation drawer |
| PASTE (⎘) | Pastes text from clipboard into terminal |
| SCROLL (⇳) | Toggles auto-scroll on/off |

## Popups (Swipe Up)

Your layout has these popups configured:

| Key | Swipe up → |
|-----|-----------|
| ⌫BKSP | ⌦DEL |
| ⌦DEL | ⌫BKSP |
| ⇱HOME | ~ (tilde) |
| ⇲END | $ (dollar) |
| ⇑PGUP | \| (pipe) |
| ⇓PGDN | / (slash) |
| SPACE | _ (underscore) |
| ↲ENTER | ; (semicolon) |

## Symbol Reference

| Symbol | Meaning |
|--------|---------|
| ⌫ | Backspace (erase left) |
| ⌦ | Delete (erase right) |
| ⇱ | Home (beginning of line) |
| ⇲ | End (end of line) |
| ⇑ | Page Up |
| ⇓ | Page Down |
| ⌨ | Toggle soft keyboard |
| ↲ | Enter / Return |
| ←↑↓→ | Arrow keys |

## How Macros Work

Macros send keys **one after another** (not simultaneously). Example:

```
{macro: "CTRL d", display: "exit"}   → sends Ctrl+d
{macro: ": w ENTER", display: "save"} → types ": w" then presses Enter
{macro: "CTRL SPACE %", display: "tmux"}  → Ctrl+Space then %
```

## Editing the Layout

File: `~/.termux/termux.properties`
After editing, run: `termux-reload-settings`

## Full Key Reference

**Modifiers:** CTRL, ALT, SHIFT, FN  
**Navigation:** HOME, END, PGUP, PGDN, UP, DOWN, LEFT, RIGHT  
**Editing:** BKSP, DEL, INS, ENTER, TAB  
**Actions:** KEYBOARD, DRAWER, PASTE, SCROLL  
**Function:** F1, F2, F3, F4, F5, F6, F7, F8, F9, F10, F11, F12  
**Literals:** ESC, SPACE, BACKSLASH (\\), QUOTE ("), APOSTROPHE (')  
**Chars:** Any character like `|`, `/`, `~`, `-`, `=`, `:`, `;`, etc.
