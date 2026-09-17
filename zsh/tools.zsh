if (( $+commands[starship] )); then
  if _dotfiles_init_code=$(command starship init zsh); then
    eval "$_dotfiles_init_code"
  else
    print -u2 -r -- "starship initialization failed (status $?)"
  fi
fi
if (( $+commands[zoxide] )); then
  if _dotfiles_init_code=$(command zoxide init zsh); then
    eval "$_dotfiles_init_code"
  else
    print -u2 -r -- "zoxide initialization failed (status $?)"
  fi
fi
unset _dotfiles_init_code
return 0
