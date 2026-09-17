status is-interactive; and type -q zoxide; or return

zoxide init fish | source

# zoxide's built-in interactive mode requires fzf; select its ranked results
# with the shared Skim helper instead.
function __zoxide_zi
    set -l candidates (command zoxide query --exclude (__zoxide_pwd) --list -- $argv)
    or return $status

    set -l result (string join \n -- $candidates | _skim --scheme path --no-multi --height 40% --prompt 'zoxide ❯ ')
    or return $status

    test -n "$result"; and __zoxide_cd "$result"
end
