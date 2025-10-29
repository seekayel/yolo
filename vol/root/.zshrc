# Path to oh-my-zsh installation
export ZSH="$HOME/.oh-my-zsh"

# Enable git plugin
plugins=(git)

# Source oh-my-zsh
source $ZSH/oh-my-zsh.sh

# Custom prompt with user@host and git info
autoload -Uz vcs_info
precmd() { vcs_info }
zstyle ":vcs_info:git:*" formats " (%b%u%c)"
zstyle ":vcs_info:*" enable git
zstyle ":vcs_info:*" check-for-changes true
zstyle ":vcs_info:*" unstagedstr "*"
zstyle ":vcs_info:*" stagedstr "+"
setopt prompt_subst
PROMPT="%F{green}%n@%m%f:%F{blue}%~%f%F{yellow}\${vcs_info_msg_0_}%f$ "

# Aliases
alias claude="claude --dangerously-skip-permissions"
alias codex="codex --dangerously-bypass-approvals-and-sandbox"
