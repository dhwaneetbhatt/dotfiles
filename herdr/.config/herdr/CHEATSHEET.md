# Herdr Cheatsheet

Prefix is **`Ctrl+a`** (press it, release, then the action key).
Press **`Ctrl+a`** then **`?`** anytime for the live in-app help.

Config: `herdr/.config/herdr/config.toml` (stowed to `~/.config/herdr/config.toml`).
Reload after edits with `herdr server reload-config` — no restart needed.

## Worktrees (via worktrunk)

Worktrees are managed by **worktrunk** (`wt`) through the herdr-worktrunk plugin,
not herdr's built-ins — worktrunk runs lifecycle hooks on create (copy gitignored
files, project init) that the built-ins lack. An fzf picker opens; press Enter on
a match to switch, or type a new name + Enter to create.

| Keys | Action |
|---|---|
| `prefix shift+g` | **Switch / create worktree** from the default branch (picker) |
| `prefix a` | **Switch / create worktree** from the current branch |
| `prefix shift+d` | **Remove** a worktree (worktrunk confirms, gates unmerged/untracked) |
| `prefix shift+m` | **Merge** a worktree into its target, then remove it |

Hooks live in each repo's `.config/wt.toml` (`pre-start` = copy env/secrets + init).
First use in a repo needs a one-time `wt config approvals add` to approve its hooks.

## Workspaces

| Keys | Action |
|---|---|
| `prefix w` | Workspace picker (popup) |
| `prefix shift+n` | New workspace |
| `prefix shift+w` | Rename workspace |
| `prefix shift+q` | Close workspace *(moved here from the default shift+d)* |
| `prefix shift+left` / `shift+right` | Previous / next workspace |

## Agents

| Keys | Action |
|---|---|
| `prefix g` | Agent/session picker (popup — like `prefix w` but for agents) |
| `prefix shift+a` / `shift+z` | Previous / next agent |
| `prefix alt+1` … `alt+9` | Jump to agent 1–9 |

In the picker: `j`/`k` move, `enter` jump, `space` expand/collapse,
`b`/`w`/`i`/`d`/`a` filter by state, type to search
(`ctrl+n`/`ctrl+p` move, `ctrl+u` clear while searching).

## Tabs

| Keys | Action |
|---|---|
| `prefix c` | New tab |
| `prefix shift+t` | Rename tab |
| `prefix p` / `shift+left` | Previous tab |
| `prefix n` / `shift+right` | Next tab |
| `prefix 1` … `9` | Switch to tab 1–9 |
| `prefix shift+,` / `shift+.` | Move tab toward front / back (reorder, like tmux `<`/`>`) |
| `prefix shift+x` | Close tab |

## Panes

| Keys | Action |
|---|---|
| `prefix v` | Split right (vertical) |
| `prefix -` | Split down (horizontal) |
| `prefix h`/`j`/`k`/`l` | Focus pane left/down/up/right |
| `prefix shift+h`/`j`/`k`/`l` | Swap pane left/down/up/right |
| `prefix tab` / `shift+tab` | Cycle pane next / previous |
| `prefix ;` | Last pane (jump back to previous) |
| `prefix z` | Zoom focused pane |
| `prefix x` | Close pane |
| `prefix r` | Resize mode (then `h`/`j`/`k`/`l`, `esc` to exit) |
| `prefix shift+p` | Rename pane |
| `prefix [` | Copy mode |
| `prefix e` | Edit scrollback in `$EDITOR` |

## Commands & Session

| Keys | Action |
|---|---|
| `prefix shift+l` | **lazygit** in a temporary pane *(custom)* |
| `prefix b` | Toggle sidebar |
| `prefix s` | Settings |
| `prefix o` | Open notification target |
| `prefix shift+r` | Reload config |
| `prefix q` | Detach client |
| `prefix ?` | Keybind help |

## Notes

- **Arrow hierarchy:** `shift`+arrows move **workspaces**; the plain-arrow /
  `shift`+arrow aliases on `previous_tab`/`next_tab` move **tabs**.
- **Shift-letter chords need a together-press:** herdr receives `shift` and the
  letter as separate key events, so a slow press drops the shift and e.g.
  `prefix shift+g` falls back to `prefix g`. Press shift+letter together and
  they work. `shift`+arrow and `shift`+digit chords carry the modifier in their
  escape sequence and are unaffected.
- **CLI fallback for worktrees** (works regardless of keybinds):
  `herdr worktree create --branch <name> [--base <ref>] [--path <dir>]`,
  `herdr worktree open --branch <name>`, `herdr worktree list`,
  `herdr worktree remove`.
- Last `herdr server reload-config` reported `status: applied` with no diagnostics.
