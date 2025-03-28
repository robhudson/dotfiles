# Path to your oh-my-zsh installation.
export ZSH="/Users/rob/.oh-my-zsh"

# Uncomment the following line to change how often to auto-update (in days).
zstyle ':omz:update' frequency 5

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
# history-substring-search
# git-prompt
plugins=(direnv gh git github nvm python starship vi-mode uv)

source $ZSH/oh-my-zsh.sh

# User configuration

export EDITOR="vim"
export LESS=-FRX # Don't `less` if the output fits on the screen.
export PYTHONDONTWRITEBYTECODE=1

source ~/.aliasrc

# Autocomplete for invoke
# source <(inv --print-completion-script zsh)

# For local bin commands I set up
export PATH="$PATH:/Users/rob/.local/bin"
# for mysql commands
export PATH="$PATH:/opt/homebrew/opt/mysql-client/bin"
# for libpq and pg_config
export PATH="$PATH:/opt/homebrew/opt/libpq/bin"
# for docker cli
#export PATH="$PATH:/Users/rob/.docker/cli-plugins"
# Set up for orbstack
. $HOME/.orbstack/shell/init.zsh

# # Set up for `nvm`
# # Not needed if plugin included.
# export NVM_DIR="$HOME/.nvm"
# [ -s "/opt/homebrew/opt/nvm/nvm.sh" ] && . "/opt/homebrew/opt/nvm/nvm.sh"  # This loads nvm

# Set up for `uv` autocompletion.
eval "$(uv generate-shell-completion zsh)"

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/Users/rob/Downloads/google-cloud-sdk/path.zsh.inc' ]; then . '/Users/rob/Downloads/google-cloud-sdk/path.zsh.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/Users/rob/Downloads/google-cloud-sdk/completion.zsh.inc' ]; then . '/Users/rob/Downloads/google-cloud-sdk/completion.zsh.inc'; fi

. "$HOME/.cargo/env"

# Shell plugin for atuin - shell history search.
eval "$(atuin init zsh --disable-up-arrow)"

ssh-add --apple-use-keychain ~/.ssh/id_ed25519

workon() {
  local project="$HOME/git/$1"
  if [[ ! -d "$project" ]]; then
    echo "Error: No directory at $project" >&2
    return 1
  fi
  cd "$project"
}

rgvenv() {
    rg --no-ignore "$1" .venv/lib/python3.12/site-packages/ --glob '*.py'
}

dotfiles() {
  /usr/bin/git --git-dir=$HOME/.dotfiles --work-tree=$HOME "$@"
}

# Rust binary aliases
function cat() {
  bat --theme 'Monokai Extended' "$@"
}
# complete -o default -o nospace -F _files cat
compdef '_files -g "*"' cat

unalias ls
function ls() {
  exa --git --time-style iso "$@"
}
# complete -o default -o nospace -F _files ls
compdef '_files -g "*"' ls
