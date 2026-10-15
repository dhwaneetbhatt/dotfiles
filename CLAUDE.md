# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview

Personal dotfiles managed without a deployment tool. The directory structure mirrors the home directory, so each top-level directory (e.g., `nvim/`) contains files that belong under `$HOME` (e.g., `nvim/.config/nvim/`). Symlinks must be created manually or via a tool like GNU stow.

## Directory Layout

- `codex/` — Durable Codex settings fragment (`config.fragment.toml`), merged into `~/.codex/config.toml` by `bin/.local/bin/codex-config-sync` (run from bootstrap). Not stowed: Codex rewrites its own config at runtime, so only hand-authored keys are tracked.
- `git/` — Git global ignore rules (`~/.config/git/ignore`)
- `ghostty/` — Ghostty terminal config (`~/.config/ghostty/config`). On macOS Ghostty loads XDG files first, then `~/Library/Application Support/com.mitchellh.ghostty/config` AFTER them, so keys in Application Support override this tracked file — keep settings here and don't duplicate them there. Sets `shell-integration-features = no-title` so the herdr title-sync plugin owns the tab title.
- `herdr/` — Herdr terminal workspace config (`~/.config/herdr/config.toml`). Plugins are not declared in `config.toml`; Herdr has no declarative plugin list, so they are installed imperatively via `herdr plugin install`. For reproducibility that install is scripted in `bootstrap` (see "Herdr Plugins" below).
- `nvim/` — Neovim config (`~/.config/nvim/`), LazyVim-based
- `ssh/` — SSH client config (`~/.ssh/config`), GitHub only (work entries excluded)
- `tmux/` — Tmux config (`~/.tmux.conf`)
- `vim/` — Legacy Vim config (`~/.vimrc`)
- `zsh/` — Zsh shell (`~/.zshrc`, `~/.zprofile`)

## Neovim Architecture

Built on [LazyVim](https://www.lazyvim.org/) starter template. Plugin manager is `lazy.nvim`.

**Entry point:** `nvim/.config/nvim/init.lua` → bootstraps `config/lazy.lua`

**Config files under `lua/config/`:**
- `lazy.lua` — lazy.nvim setup and enabled LazyVim extras
- `options.lua`, `keymaps.lua`, `autocmds.lua` — currently empty (LazyVim defaults used)

**Custom plugins under `lua/plugins/`:**
- `colorscheme.lua` — Catppuccin theme with automatic light/dark switching (polls macOS system appearance every 3s)
- `lang.lua` — Formatters: Google Java Format for Java, Prettier for JSON; markdown linting disabled
- `explorer.lua` — snacks.nvim picker configured to show hidden and gitignored files

**Enabled LazyVim extras** (from `lazyvim.json`):
- `extras.ai.claudecode` — Claude Code integration
- `extras.lang.docker`, `extras.lang.java`, `extras.lang.markdown`, `extras.lang.typescript.biome`

`lazy-lock.json` pins all plugin versions — update with `:Lazy update` inside Neovim.

## Herdr Plugins

Herdr plugins are installed via a CLI (`herdr plugin install owner/repo`), with install/enabled state stored globally per-user rather than in `config.toml`. Since there is no declarative plugin file Herdr reads, the reproducible list lives in `bootstrap` as the `herdr_plugins` array, pinned to Git tags.

- **Add a plugin:** append an entry to the `herdr_plugins` array in `bootstrap`, format `"owner/repo[/subdir]@ref=plugin.id"`. Find `plugin.id` (the manifest ID, which may differ from the repo name) by running `herdr plugin list` after a manual install. Re-running `bootstrap` installs any missing plugins idempotently (the guard greps `herdr plugin list`).
- **Pin to tags, not branches** — this is what makes the list reproducible and makes a one-time source review meaningful. Herdr plugins run unsandboxed as your user, so review a plugin's source at the pinned tag before adding it; `--yes` in bootstrap skips the interactive confirmation for unattended runs.
- **Built from source:** plugins build on install, so the required toolchain must be present. The asdf loop installs Go, which `herdr-auto-title` (Go 1.24+) needs.
- **Config:** a plugin's own settings live in its config dir (`herdr plugin config-dir <id>`), separate from the managed checkout. Keybindings for plugin actions and UI tokens for plugin output go in `herdr/.config/herdr/config.toml`.

Currently tracked:
- `kryptamine/herdr-auto-title` — auto-names Herdr's internal tabs/panes and sidebar after the running process, directory, git branch, and agent sessions. Does NOT touch the outer terminal title.
- `rjyo/herdr-window-title-sync` — syncs the OUTER terminal (Ghostty) window/tab title to the focused workspace/tab/agent, like `tmux set-titles`. Event-driven, so the Ghostty tab stays current instead of freezing at the workspace's creation directory. Needs Bun (installed by the asdf loop) and pairs with Ghostty's `shell-integration-features = no-title`. No release tags upstream, so it is pinned to a commit SHA.
- `devashish2203/herdr-worktrunk` — drives worktrunk (`wt`, in the Brewfile) for worktree switch/create/remove/merge via an fzf picker, so worktrunk's lifecycle hooks run on create. Bound over herdr's built-in worktree keys (prefix+shift+g etc.). Per-repo hooks live in `<repo>/.config/wt.toml` and need a one-time `wt config approvals add`. Needs fzf + jq.

## Tmux

- Prefix: `Ctrl+a`
- Plugin manager: TPM (`~/.tmux/plugins/tpm`)
- Key bindings: `Shift+Left/Right` to switch windows; `Prefix + </>` to reorder; vi-mode copy
- Drag-select automatically copies to macOS clipboard

## Zsh

- Framework: Oh My Zsh with Powerlevel10k theme
- Version manager: asdf (Node.js)
- FZF: `Ctrl+R` for history, `Alt+C` for directory navigation
- Lazy-loads zcompdump (24h cache) for fast startup
- History: 50,000 entries; `ls`, `cd`, `pwd`, `exit` excluded
