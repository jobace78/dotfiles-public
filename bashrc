# bashrc
#
# Notes:
#   - values found here may be overriden by values found in ~/.bashrc
#   - this bashrc should be loaded BEFORE your own bashrc...
#

#########
# alias #
#########

alias df='df -P -h'
alias grep='grep --color=auto'
alias la='ls -A -G'
alias ll='ls -G -h -l'
alias ls='ls -G'

##############
# completion #
##############

#################
# configuration #
#################

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
  eval "$(starship init bash)"
else
  if [ "${TERM}" != "linux" ]; then
    _update_ps1_install
  fi
fi
