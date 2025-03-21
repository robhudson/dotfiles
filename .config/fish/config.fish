# Remove fish greeting
set -U fish_greeting

set -x EDITOR vim
set -x LESS -FRX # Don't `less` if the output fits on the screen.
set -x PYTHONDONTWRITEBYTECODE 1

# aliases and abbrs
alias json="python -m json.tool --sort-keys"
alias printenv="printenv | sort"
abbr dc "docker compose"
abbr k "kubectl"

# dotfiles management
function dotfiles
    /usr/bin/git --git-dir=$HOME/.dotfiles --work-tree=$HOME $argv
end

# Setup for homebrew to work
/opt/homebrew/bin/brew shellenv | source

# Set up for orbstack
# Check ~/.orbstack/shell/init.fish
set -gxa PATH /Users/rob/.orbstack/bin

# For local bin commands I set up
set -x PATH $PATH /Users/rob/.local/bin
# for mysql commands
set -x PATH $PATH /opt/homebrew/opt/mysql-client/bin
# for libpq and pg_config
set -x PATH $PATH /opt/homebrew/opt/libpq/bin
# for docker cli
# export PATH="$PATH:/Users/rob/.docker/cli-plugins"


if status is-interactive
    # Activate starship - Rust-based prompt
    starship init fish | source

    # Activate atuin - shell history search
    atuin init fish | source

    # Pull in my SSH key for github etc
    ssh-add --apple-use-keychain ~/.ssh/id_ed25519

    # Activate nvm
    set -gx NVM_DIR $HOME/.nvm
    function nvm
        bash -c "source ~/.nvm/nvm.sh; nvm $argv"
    end

    # Replace `cat` with `bat`
    function cat
        bat --theme 'Monokai Extended' $argv
    end

    # Replace `ls` with `exa`
    function ls
        exa --git --time-style=iso $argv
    end
end
