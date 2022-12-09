# zshrc

##########################################################
# alias                                                  #
#                                                        #
# Notes:                                                 #
#   - this may be overriden by alias defined in ~/.zshrc #
#   - this should be loaded BEFORE your own zshrc...     #
#                                                        #
##########################################################

alias df='df -P -h'
alias grep='grep --color=auto'
alias history='fc -E -l 1'
alias la='ls -A -G'
alias ll='ls -G -h -l'
alias ls='ls -G'

###############################################################
# completion                                                  #
#                                                             #
# Notes:                                                      #
#   - this may be overriden by completion defined in ~/.zshrc #
#   - this should be loaded BEFORE your own zshrc...          #
#                                                             #
###############################################################

#
# index:
#   - system : <homebrew root>/share/zsh/site-functions
#   - user   : <home>/.local/share/zsh/site-functions
#

if [ "${commands[brew]}" ]; then
  if [ -d "${HOMEBREW_ROOT}/share/zsh/site-functions" ]; then
    fpath=("${HOMEBREW_ROOT}/share/zsh/site-functions" ${fpath})
  fi
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

##################################################################
# configuration                                                  #
#                                                                #
# Notes:                                                         #
#   - this may be overriden by configuration defined in ~/.zshrc #
#   - this should be loaded BEFORE your own zshrc...             #
#                                                                #
##################################################################

setopt \
  extended_history \
  hist_expire_dups_first \
  hist_ignore_dups \
  inc_append_history \
  interactive_comments \
  noautomenu \
  nullglob \
  promptsubst \
  shwordsplit

###########################################################
# prompt                                                  #
#                                                         #
# Notes:                                                  #
#   - this may be overriden by prompt defined in ~/.zshrc #
#   - this should be loaded BEFORE your own zshrc...      #
#                                                         #
###########################################################

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

function _install_update_ps1() {
  for i in "${precmd_functions[@]}"; do
    if [ "${i}" = '_update_ps1' ]; then
      return
    fi
  done
  precmd_functions+=(_update_ps1)
}

if [ -f "${HOME:?}"/.powerlevel10k/powerlevel10k.zsh-theme ]; then
  . "${HOME:?}"/.powerlevel10k/powerlevel10k.zsh-theme
else
  if [ "${TERM}" != "linux" ]; then
    _install_update_ps1
  fi
fi

### include ###

if [ -s "${NVM_DIR:=${HOME:?}/.nvm}"/nvm.sh ]; then
  . "${NVM_DIR}"/nvm.sh
fi

if [ -s "${PERLBREW_ROOT:=${HOME:?}/.perlbrew}"/etc/bashrc ]; then
  . "${PERLBREW_ROOT}"/etc/bashrc
fi

if [ "${commands[phpenv]}" ]; then
  eval "$(phpenv init -)"
fi

if [ "${commands[pyenv]}" ]; then
  eval "$(pyenv init -)"
  eval "$(pyenv virtualenv-init -)"
fi

if [ -s "${SDKMAN_DIR:=${HOME:?}/.sdkman}"/bin/sdkman-init.sh ]; then
  . "${SDKMAN_DIR}"/bin/sdkman-init.sh
fi
