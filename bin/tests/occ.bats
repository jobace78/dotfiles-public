#!/usr/bin/env bats

# shellcheck disable=SC2154 # set by bats
setup() {
  load test_helper
  isolate_environment
  COMPLETION="${BATS_TEST_DIRNAME}"/../../share/zsh/site-functions/_occ
  SCRIPT="${BATS_TEST_DIRNAME}"/../occ
}

@test "-H prints the usage and exits 0" {
  run bash "${SCRIPT}" -H

  [ "${status}" -eq 0 ]
  [[ ${output} == *"Usage: "*" [OPTION...] <ALIAS>"* ]]
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

@test "-l lists the aliases in ASCII order" {
  printf '%s\n' 'aliases:' '  cluster-b:' '    kind: generic' '  cluster-a:' '    kind: generic' \
    > "${HOME}"/.occ.yaml

  run bash "${SCRIPT}" -l

  [ "${status}" -eq 0 ]
  [ "${output}" = 'cluster-a cluster-b' ]
}

@test "-l with no aliases exits 1" {
  printf '%s\n' 'aliases: {}' > "${HOME}"/.occ.yaml

  run bash "${SCRIPT}" -l

  [ "${status}" -eq 1 ]
  [ "${output}" = "is '${HOME}/.occ.yaml' empty ???" ]
}

@test "-l without the configuration file exits 1" {
  run bash "${SCRIPT}" -l

  [ "${status}" -eq 1 ]
  [ "${output}" = "'${HOME}/.occ.yaml' was NOT found, exiting." ]
}

@test "an empty kubeconfig is written with its parent folders" {
  load_script

  this::print_empty_kubeconfig "${HOME}"/kube/cluster-a.yaml

  cmp <(printf '%s\n' 'apiVersion: v1' 'clusters: null' 'contexts: null' 'kind: Config' 'preferences: {}' 'users: null') \
    "${HOME}"/kube/cluster-a.yaml
}

@test "an alias field is read from the configuration file, a missing one is empty" {
  load_script
  # shellcheck disable=SC2034 # read by the script functions
  occ_yaml="${HOME}"/.occ.yaml
  printf '%s\n' 'aliases:' '  cluster-a:' '    kind: generic' > "${occ_yaml}"

  [ "$(this::helper_occ_yaml_get_alias_field cluster-a kind)" = 'generic' ]
  [ "$(this::helper_occ_yaml_get_alias_field cluster-a user_name)" = '' ]
}

@test "a generic alias gets its cluster, context and token in its kubeconfig" {
  load_script
  this::print_empty_kubeconfig "${HOME}"/cluster-a.yaml

  this::init_generic cluster-a https://api.cluster-a.example:6443 "${HOME}"/cluster-a.yaml token-a user-a

  run yq -o json -I 0 '[.clusters[0].cluster.server, .contexts[0].name, .contexts[0].context.user, .users[0].user.token]' \
    "${HOME}"/cluster-a.yaml
  [ "${output}" = '["https://api.cluster-a.example:6443","cluster-a","user-a-at-cluster-a","token-a"]' ]
}

@test "a generic alias with the changeme token gets no credentials" {
  load_script
  this::print_empty_kubeconfig "${HOME}"/cluster-a.yaml

  this::init_generic cluster-a https://api.cluster-a.example:6443 "${HOME}"/cluster-a.yaml changeme user-a

  [ "$(yq '.users | length' "${HOME}"/cluster-a.yaml)" = '0' ]
}

@test "the aptakube extension takes the icon, order and tags of the alias" {
  load_script
  this::print_empty_kubeconfig "${HOME}"/cluster-a.yaml
  this::init_generic cluster-a https://api.cluster-a.example:6443 "${HOME}"/cluster-a.yaml changeme user-a

  this::set_context_extension_aptakube cluster-a https://icons.example/a.png 2 'tag-a,tag-b' "${HOME}"/cluster-a.yaml

  run yq -o json -I 0 '.contexts[0].context.extensions' "${HOME}"/cluster-a.yaml
  [ "${output}" = '[{"name":"aptakube","extension":{"icon-url":"https://icons.example/a.png","order":2,"tags":["tag-a","tag-b"]}}]' ]
}

@test "a session of a user is valid" {
  load_script
  # shellcheck disable=SC2016 # expanded by the stub
  create_stub oc 'printf "%s\n" "${OC_WHOAMI}"; exit "${OC_STATUS}"'

  OC_STATUS=0 OC_WHOAMI='user-a' run this::session_is_valid cluster-a "${HOME}"/cluster-a.yaml

  [ "${status}" -eq 0 ]
}

@test "a session of system:anonymous is not valid" {
  load_script
  # shellcheck disable=SC2016 # expanded by the stub
  create_stub oc 'printf "%s\n" "${OC_WHOAMI}"; exit "${OC_STATUS}"'

  OC_STATUS=0 OC_WHOAMI='system:anonymous' run this::session_is_valid cluster-a "${HOME}"/cluster-a.yaml

  [ "${status}" -eq 1 ]
}

@test "a session oc cannot check is not valid" {
  load_script
  # shellcheck disable=SC2016 # expanded by the stub
  create_stub oc 'printf "%s\n" "${OC_WHOAMI}"; exit "${OC_STATUS}"'

  OC_STATUS=1 OC_WHOAMI='' run this::session_is_valid cluster-a "${HOME}"/cluster-a.yaml

  [ "${status}" -eq 1 ]
}

@test "-u unsets the current context of every kubeconfig" {
  printf '%s\n' 'aliases:' '  cluster-a:' "    kubeconfig: ${HOME}/cluster-a.yaml" > "${HOME}"/.occ.yaml
  mkdir -p "${HOME}"/.kube
  printf '%s\n' 'apiVersion: v1' 'current-context: cluster-a' 'kind: Config' \
    | tee "${HOME}"/cluster-a.yaml > "${HOME}"/.kube/config

  OCC_YAML="${HOME}"/.occ.yaml run bash "${SCRIPT}" -u

  [ "${status}" -eq 0 ]
  [ "$(cat "${HOME}"/cluster-a.yaml)" = $'apiVersion: v1\nkind: Config' ]
  [ "$(cat "${HOME}"/.kube/config)" = $'apiVersion: v1\nkind: Config' ]
}
