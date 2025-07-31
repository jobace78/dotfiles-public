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
#   - (this should be set first, do not sort) <HOMEBREW_ROOT>/bin
#   - (this should be set first, do not sort) <MISE_DATA_DIR>/shims
#   -                                         <PHPENV_ROOT>/bin
#   -                                         <PYENV_ROOT>/bin
#   -                                         <RBENV_ROOT>/bin
#   - (this should be set last, do not sort)  <HOME>/.dotfiles-public/bin
#   - (this should be set last, do not sort)  <HOME>/.local/bin
#

if [ -d "${HOMEBREW_ROOT:=/opt/homebrew}"/bin ]; then
  path=("${HOMEBREW_ROOT}"/bin ${path})
fi

if [ -d "${HOMEBREW_ROOT:=/opt/homebrew}"/sbin ]; then
  path=("${HOMEBREW_ROOT}"/sbin ${path})
fi

if [ -d "${MISE_DATA_DIR:=${XDG_DATA_HOME:-${HOME:?}/.local/share}/mise}"/shims ]; then
  path=("${MISE_DATA_DIR}"/shims ${path})
fi

if [ -d "${PHPENV_ROOT:=${HOME:?}/.phpenv}"/bin ]; then
  path=("${PHPENV_ROOT}"/bin ${path})
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

CPPFLAGS="${CPPFLAGS:--I${HOMEBREW_ROOT}/opt/libffi/include -I${HOMEBREW_ROOT}/opt/openssl@3/include -I${HOMEBREW_ROOT}/opt/sqlite/include}"
HOMEBREW_BUNDLE_FILE="${HOMEBREW_BUNDLE_FILE:-${HOME:?}/.brewfile}"
HOMEBREW_BUNDLE_NO_LOCK="${HOMEBREW_BUNDLE_NO_LOCK:-1}"
LDFLAGS="${LDFLAGS:--L${HOMEBREW_ROOT}/opt/libffi/lib -L${HOMEBREW_ROOT}/opt/openssl@3/lib -L${HOMEBREW_ROOT}/opt/sqlite/lib}"
PACKER_CACHE_DIR="${PACKER_CACHE_DIR:-${HOME:?}/.packer.d/cache}"
PACKER_PLUGIN_PATH="${PACKER_PLUGIN_PATH:-${HOME:?}/.packer.d/plugin}"
PIP_REQUIRE_VIRTUALENV="${PIP_REQUIRE_VIRTUALENV:-Y}"
PKG_CONFIG_PATH="${PKG_CONFIG_PATH:-${HOMEBREW_ROOT}/opt/libffi/lib/pkgconfig:${HOMEBREW_ROOT}/opt/openssl@3/lib/pkgconfig:${HOMEBREW_ROOT}/opt/sqlite/lib/pkgconfig}"
POWERSHELL_UPDATECHECK="${POWERSHELL_UPDATECHECK:-LTS}"
PYENV_VIRTUALENV_DISABLE_PROMPT="${PYENV_VIRTUALENV_DISABLE_PROMPT:-1}"
XDG_CACHE_HOME="${XDG_CACHE_HOME:-${HOME:?}/.cache}"
XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-${HOME:?}/.config}"
XDG_DATA_HOME="${XDG_DATA_HOME:-${HOME:?}/.local/share}"
XDG_STATE_HOME="${XDG_STATE_HOME:-${HOME:?}/.local/state}"

export CPPFLAGS HOMEBREW_BUNDLE_FILE HOMEBREW_BUNDLE_NO_LOCK LDFLAGS PACKER_CACHE_DIR PACKER_PLUGIN_PATH PIP_REQUIRE_VIRTUALENV PKG_CONFIG_PATH POWERSHELL_UPDATECHECK PYENV_VIRTUALENV_DISABLE_PROMPT XDG_CACHE_HOME XDG_CONFIG_HOME XDG_DATA_HOME XDG_STATE_HOME
