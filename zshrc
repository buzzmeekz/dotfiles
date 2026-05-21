# Oh-My-Zsh
ZSH=$HOME/.oh-my-zsh
ZSH_THEME="cobalt2"
plugins=(git gitfast last-working-dir common-aliases zsh-syntax-highlighting zsh-autosuggestions history-substring-search)
ZSH_DISABLE_COMPFIX=true
source "${ZSH}/oh-my-zsh.sh"
unalias rm

# Homebrew
export HOMEBREW_NO_ANALYTICS=1
eval "$(/opt/homebrew/bin/brew shellenv)"

# Encoding
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8

# Editor for bundler
export BUNDLER_EDITOR=code

# Aliases
[[ -f "$HOME/.aliases" ]] && source "$HOME/.aliases"

# Rails/Node binstubs from current dir
export PATH="./bin:./node_modules/.bin:$PATH:/usr/local/sbin"

# pyenv
export PYENV_ROOT="$HOME/.pyenv"
export PYENV_VIRTUALENV_DISABLE_PROMPT=1
[[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"
if command -v pyenv >/dev/null; then
  eval "$(pyenv init - zsh)"
  eval "$(pyenv virtualenv-init -)"
fi

# nvm
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"

autoload -U add-zsh-hook
load-nvmrc() {
  if nvm -v &> /dev/null; then
    local node_version="$(nvm version)"
    local nvmrc_path="$(nvm_find_nvmrc)"
    if [ -n "$nvmrc_path" ]; then
      local nvmrc_node_version=$(nvm version "$(cat "${nvmrc_path}")")
      if [ "$nvmrc_node_version" = "N/A" ]; then
        nvm install
      elif [ "$nvmrc_node_version" != "$node_version" ]; then
        nvm use --silent
      fi
    elif [ "$node_version" != "$(nvm version default)" ]; then
      nvm use default --silent
    fi
  fi
}
type -a nvm > /dev/null && add-zsh-hook chpwd load-nvmrc
type -a nvm > /dev/null && load-nvmrc

# libpq (Postgres client libs)
export PATH="/opt/homebrew/opt/libpq/bin:$PATH"

# User-local bin
export PATH="$HOME/.local/bin:$PATH"

# Keep PATH unique (zsh feature — first occurrence wins, dupes dropped)
typeset -U PATH path

# mise — must be last so nothing prepends ahead of its shims
eval "$(mise activate zsh)"
