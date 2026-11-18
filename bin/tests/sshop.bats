#!/usr/bin/env bats

# shellcheck disable=SC2154 # set by bats
setup() {
  load helpers
  isolate_environment
  COMPLETION="${BATS_TEST_DIRNAME}"/../../share/zsh/site-functions/_sshop
  SCRIPT="${BATS_TEST_DIRNAME}"/../sshop
}

@test "-H prints the usage and exits 0" {
  run bash "${SCRIPT}" -H

  [ "${status}" -eq 0 ]
  [[ ${output} == *"Usage: "*" [OPTION...] <ACCOUNT> <ARGS>"* ]]
}

@test "-U prints the usage and exits 0" {
  run bash "${SCRIPT}" -U

  [ "${status}" -eq 0 ]
  [[ ${output} == *"Usage: "* ]]
}

@test "-V prints the version and exits 0" {
  run bash "${SCRIPT}" -V

  [ "${status}" -eq 0 ]
  [[ ${output} =~ ^v[0-9]{8}$ ]]
}

@test "an unknown option prints the usage and exits 1" {
  run bash "${SCRIPT}" -Z

  [ "${status}" -eq 1 ]
  [[ ${output} == *"Usage: "* ]]
}

@test "no argument prints the usage and exits 1" {
  run bash "${SCRIPT}"

  [ "${status}" -eq 1 ]
  [[ ${output} == *"Usage: "* ]]
}

@test "the zsh completion lists the help options" {
  run diff <(print_help_options "${SCRIPT}") <(print_completion_options "${COMPLETION}")

  [ "${status}" -eq 0 ]
}

@test "-l lists the accounts but the agent config" {
  mkdir -p "${HOME}"/.config/1Password/ssh
  touch "${HOME}"/.config/1Password/ssh/{account-b,account-a,agent}.toml \
    "${HOME}"/.config/1Password/ssh/agent.toml.default

  run bash "${SCRIPT}" -l

  [ "${status}" -eq 0 ]
  [ "${output}" = 'account-a account-b' ]
}

@test "-l without the 1Password ssh folder exits 1" {
  run bash "${SCRIPT}" -l

  [ "${status}" -eq 1 ]
  [ "${output}" = "'${HOME}/.config/1Password/ssh' was NOT found, exiting." ]
}

@test "-s switches the agent config to the account" {
  mkdir -p "${HOME}"/.config/1Password/ssh
  printf '%s\n' default > "${HOME}"/.config/1Password/ssh/agent.toml.default
  printf '%s\n' account-a > "${HOME}"/.config/1Password/ssh/account-a.toml

  run bash "${SCRIPT}" -s account-a

  [ "${status}" -eq 0 ]
  [ "${output}" = "switching to 'account-a' account..." ]
  [ "$(cat "${HOME}"/.config/1Password/ssh/agent.toml)" = 'account-a' ]
}

@test "-r restores the default agent config" {
  mkdir -p "${HOME}"/.config/1Password/ssh
  printf '%s\n' default > "${HOME}"/.config/1Password/ssh/agent.toml.default
  printf '%s\n' account-a > "${HOME}"/.config/1Password/ssh/agent.toml

  run bash "${SCRIPT}" -r

  [ "${status}" -eq 0 ]
  [ "$(cat "${HOME}"/.config/1Password/ssh/agent.toml)" = 'default' ]
}

@test "-s with an unknown account exits 1 and keeps the agent config" {
  mkdir -p "${HOME}"/.config/1Password/ssh
  printf '%s\n' default > "${HOME}"/.config/1Password/ssh/agent.toml.default
  printf '%s\n' default > "${HOME}"/.config/1Password/ssh/agent.toml

  run bash "${SCRIPT}" -s account-b

  [ "${status}" -eq 1 ]
  [ "${lines[1]}" = "'${HOME}/.config/1Password/ssh/account-b.toml' was NOT found, exiting." ]
  [ "$(cat "${HOME}"/.config/1Password/ssh/agent.toml)" = 'default' ]
}

@test "-r without the default agent config exits 1" {
  mkdir -p "${HOME}"/.config/1Password/ssh

  run bash "${SCRIPT}" -r

  [ "${status}" -eq 1 ]
  [ "${lines[1]}" = "'${HOME}/.config/1Password/ssh/agent.toml.default' was NOT found, exiting." ]
}
