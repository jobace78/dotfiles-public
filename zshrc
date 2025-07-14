# zshrc
#
# Notes:
#   - values found here may be overriden by values found in ~/.zshrc
#   - this zshrc should be loaded BEFORE your own zshrc...
#

#########
# alias #
#########

alias df='df -P -h'
alias grep='grep --color=auto'
alias history='fc -i -l 1'
alias la='ls -A -G'
alias ll='ls -G -h -l'
alias ls='ls -G'

##############
# completion #
##############
#
# index:
#   -            <HOME>/.luaver/completions
#   -            <HOMEBREW_ROOT>/share/zsh/site-functions IF 'brew' is found in PATH...
#   -            <RBENV_ROOT>/completions IF 'rbenv' is found in PATH...
#   - (override) <HOME>/.dotfiles-public/share/zsh/site-functions
#   - (override) <HOME>/.local/share/zsh/site-functions
#

if [ -d "${HOME:?}"/.luaver/completions ]; then
  fpath=("${HOME:?}"/.luaver/completions ${fpath})
fi

if [ "${commands[brew]}" ]; then
  if [ -d "${HOMEBREW_ROOT}"/share/zsh/site-functions ]; then
    fpath=("${HOMEBREW_ROOT}"/share/zsh/site-functions ${fpath})
  fi
fi

if [ "${commands[rbenv]}" ]; then
  if [ -d "${RBENV_ROOT}"/completions ]; then
    fpath=("${RBENV_ROOT}"/completions ${fpath})
  fi
fi

if [ -d "${HOME:?}"/.dotfiles-public/share/zsh/site-functions ]; then
  fpath=("${HOME:?}"/.dotfiles-public/share/zsh/site-functions ${fpath})
fi

if [ -d "${HOME:?}"/.local/share/zsh/site-functions ]; then
  fpath=("${HOME:?}"/.local/share/zsh/site-functions ${fpath})
fi

if type compinit 1> /dev/null; then
  compinit
else
  autoload -U +X compinit && \
  compinit
fi

if type bashcompinit 1> /dev/null; then
  bashcompinit
else
  autoload -U +X bashcompinit && \
  bashcompinit
fi

zstyle ':completion:*' matcher-list '' 'm:{a-zA-Z}={A-Za-z}'
zstyle ':completion:*' special-dirs true

#################
# configuration #
#################

setopt \
  extended_history \
  hist_expire_dups_first \
  hist_ignore_dups \
  hist_ignore_space \
  inc_append_history \
  interactive_comments \
  noautomenu \
  nullglob \
  promptsubst \
  shwordsplit

function _update_ps1() {
  if [ -f /Library/Developer/CommandLineTools/usr/share/git-core/git-prompt.sh ]; then
    GIT_PS1_SHOWCOLORHINTS=Y
    GIT_PS1_SHOWDIRTYSTATE=Y
    GIT_PS1_SHOWSTASHSTATE=Y
    GIT_PS1_SHOWUNTRACKEDFILES=Y
    GIT_PS1_SHOWUPSTREAM=verbose
    . /Library/Developer/CommandLineTools/usr/share/git-core/git-prompt.sh
    PS1='%n %~ $(__git_ps1 "(%s) ")%# '
  else
    PS1='%n %~ %# '
  fi
}

function _update_ps1_install() {
  for i in "${precmd_functions[@]}"; do
    if [ "${i}" = '_update_ps1' ]; then
      return
    fi
  done
  precmd_functions+=(_update_ps1)
}

if [ "${commands[starship]}" ]; then
  eval "$(starship init zsh)"
else
  if [ "${TERM}" != 'linux' ]; then
    _update_ps1_install
  fi
fi

# direnv
#
if [ "${commands[direnv]}" ]; then
  eval "$(direnv hook zsh)"
fi

# luaver
#
if [ -s "${HOME:?}"/.luaver/luaver ]; then
  . "${HOME:?}"/.luaver/luaver
fi

# mise
#
if [ "${commands[mise]}" ]; then
  eval "$(mise activate zsh)"
fi

# nvm
#
if [ -s "${NVM_DIR:=${HOME:?}/.nvm}"/nvm.sh ]; then
  . "${NVM_DIR}"/nvm.sh
fi

# packer
#
if [ "${commands[packer]}" ]; then
  complete -C packer -o nospace packer
fi

# perlbrew
#
if [ -s "${PERLBREW_ROOT:=${HOME:?}/.perlbrew}"/etc/bashrc ]; then
  . "${PERLBREW_ROOT}"/etc/bashrc
fi

# phpenv
#
if [ "${commands[phpenv]}" ]; then
  eval "$(phpenv init -)"
fi

# pyenv
#
if [ "${commands[pyenv]}" ]; then
  eval "$(pyenv init -)"
  eval "$(pyenv virtualenv-init -)"
fi

# rbenv
#
if [ "${commands[rbenv]}" ]; then
  eval "$(rbenv init - --no-rehash zsh)"
fi

# sdkman
#
if [ -s "${SDKMAN_DIR:=${HOME:?}/.sdkman}"/bin/sdkman-init.sh ]; then
  . "${SDKMAN_DIR}"/bin/sdkman-init.sh
fi

# tofu
#
if [ "${commands[tofu]}" ]; then
  complete -C tofu -o nospace tofu
fi
