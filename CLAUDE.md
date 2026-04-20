# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview

Personal dotfiles managed without a deployment tool. The directory structure mirrors the home directory, so each top-level directory (e.g., `nvim/`) contains files that belong under `$HOME` (e.g., `nvim/.config/nvim/`). Symlinks must be created manually or via a tool like GNU stow.

## Directory Layout

- `git/` — Git global ignore rules (`~/.config/git/ignore`)
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
