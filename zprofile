# zprofile
#
# Notes:
#   - values found here may be overriden by values found in ~/.zshenv
#   - this zprofile should be loaded BEFORE your own zprofile...
#

#########
# paths #
#########
#
# index:
#   - system : /opt/dotnet
#   - system : /opt/powershell
#   - system : <homebrew root>/bin
#   - system : <homebrew root>/sbin
#   - user   : <home>/.local/bin
#   - user   : <home>/.phpenv/bin
#   - user   : <home>/.pyenv/bin
#

if [ -d "${DOTNET_ROOT:=/opt/dotnet}" ]; then
  path=("${DOTNET_ROOT}" ${path})
fi

if [ -d "${POWERSHELL_ROOT:=/opt/powershell}" ]; then
  path=("${POWERSHELL_ROOT}" ${path})
fi

case "$(uname -m)" in
  arm64)
    HOMEBREW_ROOT="${HOMEBREW_ROOT:=/opt/homebrew}"
    ;;
  *)
    HOMEBREW_ROOT="${HOMEBREW_ROOT:=/usr/local}"
    ;;
esac

if [ -d "${HOMEBREW_ROOT}/bin" ]; then
  path=("${HOMEBREW_ROOT}/bin" ${path})
fi

if [ -d "${HOMEBREW_ROOT}/sbin" ]; then
  path=("${HOMEBREW_ROOT}/sbin" ${path})
fi

if [ -d "${HOME:?}/.local/bin" ]; then
  path=("${HOME:?}/.local/bin" ${path})
fi

if [ -d "${PHPENV_ROOT:=${HOME:?}/.phpenv}/bin" ]; then
  path=("${PHPENV_ROOT}/bin" ${path})
fi

if [ -d "${PYENV_ROOT:=${HOME:?}/.pyenv}/bin" ]; then
  path=("${PYENV_ROOT}/bin" ${path})
fi

if [ "${commands[pyenv]}" ]; then
  eval "$(pyenv init --path)"
fi

export PATH

#############
# variables #
#############

PIP_REQUIRE_VIRTUALENV="${PIP_REQUIRE_VIRTUALENV:-Y}"
XDG_CACHE_HOME="${XDG_CACHE_HOME:-${HOME:?}/.cache}"
XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-${HOME:?}/.config}"
XDG_DATA_HOME="${XDG_DATA_HOME:-${HOME:?}/.local/share}"

export PIP_REQUIRE_VIRTUALENV XDG_CACHE_HOME XDG_CONFIG_HOME XDG_DATA_HOME
