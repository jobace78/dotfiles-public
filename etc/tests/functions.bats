#!/usr/bin/env bats

# shellcheck disable=SC2154 # set by bats
setup() {
  bats_require_minimum_version 1.5.0
  unset DECORATION_CHARACTER
  # shellcheck source=../functions.shconf
  . "${BATS_TEST_DIRNAME}"/../functions.shconf
}

@test "functions::exit prints the message to stdout and exits with the code" {
  run --separate-stderr functions::exit 3 'done'

  [ "${status}" -eq 3 ]
  [ "${output}" = 'done' ]
  [ "${stderr}" = '' ]
}

@test "functions::exit exits 1 on a code that is not a number" {
  run functions::exit 'not-a-number'

  [ "${status}" -eq 1 ]
  [ "${output}" = '' ]
}

@test "functions::exit without arguments exits 1 silently" {
  run functions::exit

  [ "${status}" -eq 1 ]
  [ "${output}" = '' ]
}

@test "functions::stdout joins its arguments on stdout" {
  run --separate-stderr functions::stdout 'one' 'two'

  [ "${output}" = 'one two' ]
  [ "${stderr}" = '' ]
}

@test "functions::stderr joins its arguments on stderr" {
  run --separate-stderr functions::stderr 'one' 'two'

  [ "${output}" = '' ]
  [ "${stderr}" = 'one two' ]
}

@test "functions::print_to_stdout_decorated boxes the message with #" {
  functions::print_to_stdout_decorated 'abc' 1> "${BATS_TEST_TMPDIR}"/stdout 2> "${BATS_TEST_TMPDIR}"/stderr

  cmp <(printf '\n#######\n# abc #\n#######\n\n') "${BATS_TEST_TMPDIR}"/stdout
  [ ! -s "${BATS_TEST_TMPDIR}"/stderr ]
}

@test "functions::print_to_stderr_decorated boxes the message with the first DECORATION_CHARACTER" {
  DECORATION_CHARACTER='=-' functions::print_to_stderr_decorated 'abc' \
    1> "${BATS_TEST_TMPDIR}"/stdout 2> "${BATS_TEST_TMPDIR}"/stderr

  cmp <(printf '\n=======\n= abc =\n=======\n\n') "${BATS_TEST_TMPDIR}"/stderr
  [ ! -s "${BATS_TEST_TMPDIR}"/stdout ]
}

@test "functions::log_to_stdout prefixes the message with the date" {
  run functions::log_to_stdout 'started'

  [[ ${output} =~ ^\[[0-9]{4}-[0-9]{2}-[0-9]{2}\ [0-9]{2}:[0-9]{2}:[0-9]{2}[+-][0-9]{2}:[0-9]{2}\]\ started$ ]]
}

@test "functions::catch_all exits 0 silently on success" {
  run --separate-stderr functions::catch_all 0

  [ "${status}" -eq 0 ]
  [ "${output}${stderr}" = '' ]
}

@test "functions::catch_all names the signal on stderr and keeps its code" {
  run --separate-stderr functions::catch_all 130 SIGINT

  [ "${status}" -eq 130 ]
  [ "${stderr}" = '*** SIGINT caught ***' ]
}

@test "functions::catch_all names the failed line on stderr and keeps its code" {
  run --separate-stderr functions::catch_all 2

  [ "${status}" -eq 2 ]
  [[ ${stderr} =~ ^\*\*\*\ exit\ code\ \<\<\ 2\ \>\>\ on\ line\ [0-9]+\ .+\ \*\*\*$ ]]
}
