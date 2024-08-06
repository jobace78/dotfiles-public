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
#   - system-wide          : <HOMEBREW_ROOT>/bin
#   - user-wide            : <PHPENV_ROOT>/bin
#   - user-wide            : <PYENV_ROOT>/bin
#   - user-wide (override) : <HOME>/.local/bin
#

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

if [ -d "${PHPENV_ROOT:=${HOME:?}/.phpenv}/bin" ]; then
  path=("${PHPENV_ROOT}/bin" ${path})
fi

if [ -d "${PYENV_ROOT:=${HOME:?}/.pyenv}/bin" ]; then
  path=("${PYENV_ROOT}/bin" ${path})
fi

if [ "${commands[pyenv]}" ]; then
  eval "$(pyenv init --path)"
fi

if [ -d "${HOME:?}/.local/bin" ]; then
  path=("${HOME:?}/.local/bin" ${path})
fi

#############
# variables #
#############

CPPFLAGS="-I${HOMEBREW_ROOT}/opt/libffi/include -I${HOMEBREW_ROOT}/opt/openssl@1.1/include -I${HOMEBREW_ROOT}/opt/sqlite/include"
LDFLAGS="-L${HOMEBREW_ROOT}/opt/libffi/lib -L${HOMEBREW_ROOT}/opt/openssl@1.1/lib -L${HOMEBREW_ROOT}/opt/sqlite/lib"
PIP_REQUIRE_VIRTUALENV="${PIP_REQUIRE_VIRTUALENV:-Y}"
PKG_CONFIG_PATH="${HOMEBREW_ROOT}/opt/libffi/lib/pkgconfig:${HOMEBREW_ROOT}/opt/openssl@1.1/lib/pkgconfig:${HOMEBREW_ROOT}/opt/sqlite/lib/pkgconfig"
PYENV_VIRTUALENV_DISABLE_PROMPT="${PYENV_VIRTUALENV_DISABLE_PROMPT:-1}"
XDG_CACHE_HOME="${XDG_CACHE_HOME:-${HOME:?}/.cache}"
XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-${HOME:?}/.config}"
XDG_DATA_HOME="${XDG_DATA_HOME:-${HOME:?}/.local/share}"

export CPPFLAGS LDFLAGS PIP_REQUIRE_VIRTUALENV PKG_CONFIG_PATH PYENV_VIRTUALENV_DISABLE_PROMPT XDG_CACHE_HOME XDG_CONFIG_HOME XDG_DATA_HOME
