autoload -U compinit; compinit
autoload -U promptinit; promptinit

prompt pure
PURE_PROMPT_SYMBOL=▲
PURE_PROMPT_VICMD_SYMBOL=△

alias nv="nvim"
alias g="lazygit"

source <(fzf --zsh)
export FZF_DEFAULT_OPTS="$FZF_DEFAULT_OPTS \
  --prompt='➜ ' \
  --marker='✓' \
  --highlight-line \
  --info=inline-right \
  --ansi \
  --layout=reverse \
  --border=none \
  --color=bg+:#283457 \
  --color=bg:#1a1b26 \
  --color=border:#27a1b9 \
  --color=fg:#c0caf5 \
  --color=gutter:-1 \
  --color=header:#ff9e64 \
  --color=hl+:#2ac3de \
  --color=hl:#2ac3de \
  --color=info:#545c7e \
  --color=marker:#ff007c \
  --color=pointer:#ff007c \
  --color=prompt:#2ac3de \
  --color=query:#c0caf5:regular \
  --color=scrollbar:#27a1b9 \
  --color=separator:#ff9e64 \
  --color=spinner:#ff007c \
"
