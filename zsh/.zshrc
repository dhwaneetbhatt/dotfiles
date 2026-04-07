# OPENSPEC:START
# OpenSpec shell completions configuration
fpath=("/Users/dhwaneet.bhatt/.oh-my-zsh/custom/completions" $fpath)
autoload -Uz compinit
compinit
# OPENSPEC:END

# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${USER}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${USER}.zsh"
fi

# --- 1. PRE-STARTUP PERFORMANCE ---
# Periodically re-compile zcompdump to keep completion fast
# This checks if the dump file is older than 24h
ZSH_COMPDUMP="${ZSH_CACHE_DIR:-$HOME/.cache}/zcompdump-${HOST}-${ZSH_VERSION}"
autoload -Uz compinit
if [[ -n ${ZSH_COMPDUMP}(#qN.m-24) ]]; then
  compinit -C
else
  compinit -d "$ZSH_COMPDUMP"
fi

# --- 2. CORE OMZ SETUP ---
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="powerlevel10k/powerlevel10k"

# Performance flags for OMZ
DISABLE_UNTRACKED_FILES_DIRTY="true"
COMPLETION_WAITING_DOTS="true"

# Only include internal OMZ plugins here
plugins=(git tmux) 

# Load OMZ ONCE
source $ZSH/oh-my-zsh.sh

# --- 3. ASYNCHRONOUS / LATE LOADING ---
# Load heavy UI plugins AFTER OMZ core
source_if_exists() {
    [[ -f "$1" ]] && source "$1"
}

# Syntax highlighting MUST be sourced last
source_if_exists "$ZSH_CUSTOM/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh"
source_if_exists "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"

# --- 4. LAZY-LOAD EXTERNAL TOOLS ---

# Load ASDF fully at startup (Slower startup, but Node always works)
[[ -f /opt/homebrew/opt/asdf/libexec/asdf.sh ]] && . /opt/homebrew/opt/asdf/libexec/asdf.sh

# FZF Integration (Fixed for Ctrl+R)
# Instead of a function, we source the shell integration directly.
# This is what enables Ctrl+R and Alt+C.
export FZF_DEFAULT_COMMAND='fd --type f'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
if [[ -f ~/.fzf.zsh ]]; then
  source ~/.fzf.zsh
elif [[ -x /opt/homebrew/bin/fzf ]]; then
  # If ~/.fzf.zsh doesn't exist, use the modern brew-style init
  eval "$(fzf --zsh)"
fi

# --- 5. PATH & ENVIRONMENT ---
# Use typeset -U to ensure PATH remains unique (no duplicates)
typeset -U path PATH
path=(
  /opt/homebrew/bin
  /opt/homebrew/sbin
  /opt/homebrew/opt/curl/bin
  /opt/homebrew/opt/unzip/bin
  $HOME/.asdf/shims
  /Users/dhwaneet.bhatt/.local/bin
  $path
)

# --- 6. SHELL HISTORY ---
HISTFILE="$HOME/.zsh_history"
HISTSIZE=50000
SAVEHIST=50000 # 1,000,000 is overkill and can slow down some plugins
HISTORY_IGNORE="(ls|cd|pwd|exit|cd ..|ls *)"

# This hook prevents the ignored patterns from being saved to disk
zshaddhistory() {
    emulate -L zsh
    [[ ! $1 =~ $HISTORY_IGNORE ]]
}

setopt EXTENDED_HISTORY 
setopt SHARE_HISTORY 
setopt HIST_IGNORE_ALL_DUPS 
setopt HIST_IGNORE_SPACE 
setopt HIST_REDUCE_BLANKS 
setopt HIST_VERIFY

# --- 7. FUNCTIONS & ALIASES ---
autoload -U add-zsh-hook

alias zshconfig="nvim ~/.zshrc"
alias reload="source ~/.zshrc"

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

