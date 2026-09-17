set -gx EDITOR nvim
set -gx VISUAL nvim
set -g fish_greeting

function fish_prompt
    set_color brgreen
    printf '%s' (prompt_pwd)
    set_color normal
    printf '%s> ' (fish_git_prompt)
end

if status is-interactive
    abbr -a v nvim
    abbr -a g lazygit
    abbr -a h herdr
end
