<!-- markdownlint-disable MD060 -->
# Termux Extra Keys — Complete Reference

## Your Current Layout (2 rows, 9 keys each)

```text
Row 1: ESC  TAB  ⌫BKSP  ⌦DEL  ⇱HOME  ↑  ⇲END  ⇑PGUP  ⇓PGDN
Row 2: CTRL  ALT  SHIFT  ⌨KBD  ←  ↓  →  SPACE  ↲ENTER
```

## How Special Modifier Buttons Work

Each toggles state: tap activates for next keypress, long-press locks on.
Tap again to deactivate. **Each can appear ONLY ONCE in the layout.**

| Button | Tap                  | Long-press              |
|--------|----------------------|-------------------------|
| CTRL   | Activates next press | Locks on                |
| ALT    | Activates next press | Locks on                |
| SHIFT  | Activates next press | Locks on                |
| FN     | Activates next press | Locks on                |

## Action Keys

| Key               | What it does                    |
|-------------------|---------------------------------|
| KEYBOARD (⌨)      | Toggles soft keyboard on/off    |
| DRAWER (☰)        | Opens/closes the nav drawer     |
| PASTE (⎘)         | Pastes from clipboard           |
| SCROLL (⇳)        | Toggles auto-scroll             |

## Popups (Swipe Up)

Your layout has these popups configured:

| Key      | Swipe up       |
|----------|----------------|
| ⌫BKSP    | ⌦DEL           |
| ⌦DEL     | ⌫BKSP          |
| ⇱HOME    | ~ (tilde)      |
| ⇲END     | $ (dollar)     |
| ⇑PGUP    | \| (pipe)      |
| ⇓PGDN    | / (slash)      |
| SPACE    | _ (underscore) |
| ↲ENTER   | ; (semicolon)  |

## Symbol Reference

| Symbol | Meaning                  |
|--------|--------------------------|
| ⌫      | Backspace (erase left)   |
| ⌦      | Delete (erase right)     |
| ⇱      | Home (beginning of line) |
| ⇲      | End (end of line)        |
| ⇑      | Page Up                  |
| ⇓      | Page Down                |
| ⌨      | Toggle soft keyboard     |
| ↲      | Enter / Return           |
| ←↑↓→  | Arrow keys               |

## How Macros Work

Macros send keys **one after another** (not simultaneously). Example:

```properties
{macro: "CTRL d", display: "exit"}       → Ctrl+d
{macro: ": w ENTER", display: "save"}    → types ": w" then Enter
{macro: "CTRL SPACE %", display: "tmux"} → Ctrl+Space then %
```

## Editing the Layout

File: `~/.termux/termux.properties`
After editing, run: `termux-reload-settings`

## Full Key Reference

**Modifiers:** CTRL, ALT, SHIFT, FN
**Navigation:** HOME, END, PGUP, PGDN, UP, DOWN, LEFT, RIGHT
**Editing:** BKSP, DEL, INS, ENTER, TAB
**Actions:** KEYBOARD, DRAWER, PASTE, SCROLL
**Function:** F1-F12
**Literals:** ESC, SPACE, BACKSLASH (\\), QUOTE ("), APOSTROPHE (')
**Chars:** Any character like `|`, `/`, `~`, `-`, `=`, `:`, `;`, etc.
