# shellcheck shell=bash

#######################################
# Put a stub command first on PATH that logs each call to '<tmp>/<name>.log' and then runs the given body.
# Globals:
#   BATS_TEST_TMPDIR
#   PATH
# Arguments:
#   1 - command name (required, string)
#   2 - body (optional, string, defaults to ':')
# Outputs:
#   None
# Returns:
#   None
#######################################
create_stub() {
  mkdir -p "${BATS_TEST_TMPDIR:?}"/bin
  printf '%s\n' '#!/usr/bin/env bash' "printf '%s\\n' \"\${*}\" >> '${BATS_TEST_TMPDIR}/${1:?}.log'" "${2:-:}" \
    > "${BATS_TEST_TMPDIR}"/bin/"${1}"
  chmod 755 "${BATS_TEST_TMPDIR}"/bin/"${1}"
  export PATH="${BATS_TEST_TMPDIR}/bin:${PATH}"
}

#######################################
# Isolate a test: a temporary HOME and none of the variables the scripts read from the caller.
# Globals:
#   BATS_TEST_TMPDIR
#   HOME
# Arguments:
#   None
# Outputs:
#   None
# Returns:
#   None
#######################################
isolate_environment() {
  export HOME="${BATS_TEST_TMPDIR:?}"
  unset KUBECONFIG OCC_YAML SCRIPT_DEBUG SSH_AUTH_SOCK TMUX
}

#######################################
# Load the script functions, and the library functions they call, without running main().
# Globals:
#   BATS_TEST_DIRNAME
#   SCRIPT
# Arguments:
#   None
# Outputs:
#   None
# Returns:
#   None
#######################################
# shellcheck disable=SC2154 # set by bats
load_script() {
  # shellcheck source=../../etc/functions.shconf
  . "${BATS_TEST_DIRNAME}"/../../etc/functions.shconf
  # shellcheck source=/dev/null
  . "${SCRIPT:?}"
}

#######################################
# Print the options of a zsh completion as '-X[description]', one per line, in ASCII order.
# Arguments:
#   1 - completion file path (required, string)
# Outputs:
#   Options to stdout.
# Returns:
#   None
#######################################
print_completion_options() {
  sed -n -E 's/^ *"(-[A-Za-z]\[[^]]*\])[^"]*" \\$/\1/p' "${1:?}" | LC_ALL=C sort
}

#######################################
# Print the options of a script help as '-X[description]', one per line, in ASCII order.
# Arguments:
#   1 - script file path (required, string)
# Outputs:
#   Options to stdout.
# Returns:
#   None
#######################################
print_help_options() {
  bash "${1:?}" -H | sed -n -E 's/^    (-[A-Za-z])( <[^>]*>)? +(.*)$/\1[\3]/p' | LC_ALL=C sort
}
