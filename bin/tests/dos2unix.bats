#!/usr/bin/env bats

# shellcheck disable=SC2154 # set by bats
setup() {
  load test_helper
  isolate_environment
  COMPLETION="${BATS_TEST_DIRNAME}"/../../share/zsh/site-functions/_dos2unix
  SCRIPT="${BATS_TEST_DIRNAME}"/../dos2unix
}

@test "-H prints the usage and exits 0" {
  run bash "${SCRIPT}" -H

  [ "${status}" -eq 0 ]
  [[ ${output} == *"Usage: "*" [OPTION...] FILE"* ]]
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

@test "converts the line endings to LF on stdout" {
  printf 'a\r\nb\rc\n' > "${HOME}"/given.txt
  printf 'a\nb\nc\n' > "${HOME}"/expected.txt

  bash "${SCRIPT}" "${HOME}"/given.txt > "${HOME}"/converted.txt

  cmp "${HOME}"/expected.txt "${HOME}"/converted.txt
  cmp <(printf 'a\r\nb\rc\n') "${HOME}"/given.txt
}

@test "a file that cannot be read exits 1" {
  run bash "${SCRIPT}" "${HOME}"/missing.txt

  [ "${status}" -eq 1 ]
  [ "${output}" = "'${HOME}/missing.txt' was NOT readable, exiting." ]
}
