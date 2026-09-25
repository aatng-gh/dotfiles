# ---- prompt ----
zstyle ':prompt:pure:path' color cyan
zstyle ':prompt:pure:prompt:success' color green
zstyle ':prompt:pure:prompt:error' color red
autoload -U promptinit 2>/dev/null
if promptinit 2>/dev/null; then
  if (( ${prompt_themes[(Ie)pure]} )); then
    prompt pure
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
