# zprofile
#
# Notes:
#   - values found here may be overriden by values found in ~/.zprofile
#   - this zprofile should be loaded BEFORE your own zprofile...
#

#########
# paths #
#########
#
# index:
#   -            <DOTNET_ROOT>
#   -            <HOMEBREW_ROOT>/bin
#   -            <PHPENV_ROOT>/bin
#   -            <POWERSHELL_ROOT>
#   -            <PYENV_ROOT>/bin
#   -            <RBENV_ROOT>/bin
#   - (override) <HOME>/.dotfiles-public/bin
#   - (override) <HOME>/.local/bin
#

if [ -d "${DOTNET_ROOT:=/opt/dotnet}" ]; then
  path=("${DOTNET_ROOT}" ${path})
fi

if [ -d "${HOMEBREW_ROOT:=/opt/homebrew}"/bin ]; then
  path=("${HOMEBREW_ROOT}"/bin ${path})
fi

if [ -d "${PHPENV_ROOT:=${HOME:?}/.phpenv}"/bin ]; then
  path=("${PHPENV_ROOT}"/bin ${path})
fi

if [ -d "${POWERSHELL_ROOT:=/opt/powershell}" ]; then
  path=("${POWERSHELL_ROOT}" ${path})
fi

if [ -d "${PYENV_ROOT:=${HOME:?}/.pyenv}"/bin ]; then
  path=("${PYENV_ROOT}"/bin ${path})
fi

if [ "${commands[pyenv]}" ]; then
  eval "$(pyenv init --path)"
fi

if [ -d "${RBENV_ROOT:=${HOME:?}/.rbenv}"/bin ]; then
  path=("${RBENV_ROOT}"/bin ${path})
fi

if [ -d "${HOME:?}"/.dotfiles-public/bin ]; then
  path=("${HOME:?}"/.dotfiles-public/bin ${path})
fi

if [ -d "${HOME:?}"/.local/bin ]; then
  path=("${HOME:?}"/.local/bin ${path})
fi

#############
# variables #
#############

CPPFLAGS="-I${HOMEBREW_ROOT}/opt/libffi/include -I${HOMEBREW_ROOT}/opt/openssl@3/include -I${HOMEBREW_ROOT}/opt/sqlite/include"
HOMEBREW_BUNDLE_FILE="${HOME:?}"/.brewfile
HOMEBREW_BUNDLE_NO_LOCK=1
LDFLAGS="-L${HOMEBREW_ROOT}/opt/libffi/lib -L${HOMEBREW_ROOT}/opt/openssl@3/lib -L${HOMEBREW_ROOT}/opt/sqlite/lib"
PIP_REQUIRE_VIRTUALENV=Y
PKG_CONFIG_PATH="${HOMEBREW_ROOT}/opt/libffi/lib/pkgconfig:${HOMEBREW_ROOT}/opt/openssl@3/lib/pkgconfig:${HOMEBREW_ROOT}/opt/sqlite/lib/pkgconfig"
POWERSHELL_UPDATECHECK=LTS
PYENV_VIRTUALENV_DISABLE_PROMPT=1
XDG_CACHE_HOME="${XDG_CACHE_HOME:-${HOME:?}/.cache}"
XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-${HOME:?}/.config}"
XDG_DATA_HOME="${XDG_DATA_HOME:-${HOME:?}/.local/share}"

export CPPFLAGS HOMEBREW_BUNDLE_FILE HOMEBREW_BUNDLE_NO_LOCK LDFLAGS PIP_REQUIRE_VIRTUALENV PKG_CONFIG_PATH POWERSHELL_UPDATECHECK PYENV_VIRTUALENV_DISABLE_PROMPT XDG_CACHE_HOME XDG_CONFIG_HOME XDG_DATA_HOME
