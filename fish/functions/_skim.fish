function _skim --description 'Run Skim with shared defaults'
    if not type -q sk
        echo 'Skim is required: brew install sk' >&2
        return 127
    end

    command sk --reverse --border plain --info inline \
        --selector '◆' --multi-selector '◇' $argv
end
