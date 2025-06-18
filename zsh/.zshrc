autoload -U compinit; compinit
autoload -U promptinit; promptinit

alias nv="nvim"
alias g="lazygit"

source <(fzf --zsh)
export FZF_DEFAULT_OPTS="
  --prompt='☉ ' \
  --marker='✓' \
  --layout=reverse
  --color=bg:#192330,fg:#cdcecf
  --color=bg+:#2b3b51,fg+:#cdcecf
  --color=hl:#dbc074,hl+:#e0c989
  --color=gutter:-1
  --color=pointer:#c94f6d,marker:#81b29a,header:#719cd6
  --color=info:#9d79d6,prompt:#63cdcf,spinner:#63cdcf
"

eval "$(starship init zsh)"
