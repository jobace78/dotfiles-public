#!/usr/bin/env bats

# shellcheck disable=SC2154 # set by bats
setup() {
  load helpers
  isolate_environment
  SCRIPT="${BATS_TEST_DIRNAME}"/../update-completion
}

@test "-H prints the usage and exits 0" {
  run bash "${SCRIPT}" -H

  [ "${status}" -eq 0 ]
  [[ ${output} == *"Usage: "*" [OPTION...]"* ]]
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

@test "a command's completion is written from its completion zsh output" {
  load_script
  mkdir -p "${HOME}"/.local/share/zsh/site-functions
  create_stub tool-a 'printf "%s\n" "#compdef tool-a"'

  run this::completion_zsh tool-a

  [ "${output}" = "creating '${HOME}/.local/share/zsh/site-functions/_tool-a'..." ]
  [ "$(cat "${HOME}"/.local/share/zsh/site-functions/_tool-a)" = '#compdef tool-a' ]
  [ "$(cat "${HOME}"/tool-a.log)" = 'completion zsh' ]
}

@test "the completion of a missing command is removed" {
  load_script
  mkdir -p "${HOME}"/.local/share/zsh/site-functions
  touch "${HOME}"/.local/share/zsh/site-functions/_tool-missing

  run this::completion_zsh tool-missing

  [ "${status}" -eq 0 ]
  [ "${output}" = '' ]
  run test -e "${HOME}"/.local/share/zsh/site-functions/_tool-missing
  [ "${status}" -eq 1 ]
}
