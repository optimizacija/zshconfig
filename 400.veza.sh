#!/bin/zsh
alias cdc='cd /Users/Shared/dev/src/github.com/cookieai-inc/cookieai-core'
export CDPATH='/Users/Shared/dev/src/github.com/cookieai-inc/cookieai-core'


# ALIASES

# bazel run
alias bazn='bazel run'
# bazel record
alias bazrec='bazel run --config=record'
# bazel record and skip extraction
alias bazrecskip='bazel run --config=record --define=skip_test_extraction=true'


# MISC 

function bazexpunge {
    bazel clean --expunge
}


# bazel run lint go fix
# LINTERS

function bazlintdepguard {
   bazel run //tools:lint bazeldepguard 
}


function bazlintgo {
    bazel run //tools:lint go -- --fix
}

function bazlintbuildifier {
   bazel run //:buildifier 
}

# GENERATE COMMANDS

function bazgenwcedges {
    # bazel gen wildcard edges
    bazel run //controlp/internal/graph/cmd/genwildcardedges -- -output `realpath internal/graph_schema/wildcard_edges.go`
}

function bazgenpipelinecfg {
    # bazel gen pipeline configuration (pipeline_configuration.generated.json)
    bazel run //agents/dev/cmd/cfggenerator
}

function bazgenproto() {
    # bazel gen proto files
   bazel run //tools:genproto 
   bazel run //tools:lint protobuf_breaking 
}

function bazgenfp {
    # bazel gen (reachability) fingerprint
    bazel run //controlp/internal/graph/cmd/genreachability -- \
        -output-reachability-fingerprint `realpath controlp/internal/graph/precomputed_reachability_fingerprint.txt` \
        -output-reachability `realpath controlp/internal/graph/precomputed_reachability_map.go` \
        -output-graphplanner `realpath controlp/internal/graph/graphplanner`
}

function bazgennl {
    # bazel gen node list
    bazel run //internal/graph_schema/cmd/nodelist -- -graph-level=ALL -output `realpath frontend/scripts/NodeTypes.json`
}


# DOCKER & KUBERNETS (clean/upgrade)

function bazcleandocker() {
    # bazel clean docker
    bazel run //tools/cmd/dockerclean
    scripts/devenv/start_docker_registry.sh
    bazel run //tools/cmd/kubecreate -- up -t --debug
}

function bazhardcleandocker() {
    # bazel hard clean docker
    bazel run //tools/cmd/dockerclean
    docker ps -a | awk 'NR > 1 {print $1}' | xargs -I {} docker kill {} 2&>/dev/null 
    docker system prune -f 
    docker volume prune -f
    bazel run //tools/cmd/dockerclean
    scripts/devenv/start_docker_registry.sh
    bazel run //tools/cmd/kubecreate -- up -t --debug
}

function bazut {
    # bazel ugprade tenant
    bazel run //tools/cmd/kubecreate -- tenant upgrade -n tenant1 
}


# GIT

function count_manual_changes {
    # $1: master
    # $2: head
    # master..head
    git diff --stat "$1".."$2" ':!*.json' ':!*.pb.go' ':!*.bazel' ':!*.copyist' ':!*tar.gz' ':!*.bzl' | \
        sed -nE 's/.*\| *([0-9]+).*/\1/p' | \
        awk '{s+=$1} END {print s}'
}


# KUBERNETES (logging)

function kpf_neo4j {
   kubectl port-forward -n tenant1-cp cp-neo4j-historical-0 7687:7687 7474:7474 
}

function log_all {
    stern -n tenant1-cp --color=always '.*' 2>&1
}

function log_all_fmt_deprecated {
   stern -n tenant1-cp '.*' --color=always 2>&1 |\
       awk '{ print $1 " " $2; $1=$2=""; sub(/^ */, ""); print $0; }' | \
       jq -R -r '. as $raw | try (fromjson | if has("ts") then .ts |= strftime("%Y-%m-%d %H:%M:%S") else . end) catch $raw'
}

function log_err {
    stern -n tenant1-cp --color=always '.*' 2>&1 | grep '"level":"error"'
}

function log_parser {
    kubectl logs -f -ntenant1-cp -l app=cp-parser-historical
}

function log_extractor {
   kubectl logs -f -ntenant1-dp -l app=agent-manager 
}

function log_frontend {
   kubectl logs -f -ntenant1-cp -l app=frontend 
}

function log_frontend {
   kubectl logs -f -ntenant1-cp -l app=cp-api
}

function bazgenpermap {
   bazel run //agents/azure/permap/cmd/genpermap 
}


# OAA

function oaaextract_application {
    bazel run //agents/dev/cmd/agentrunner extract custom_provider_application
}

function oaaextract_principal {
    bazel run //agents/dev/cmd/agentrunner extract custom_provider_principal
}

function oaacreatetemplate {
    go run github.com/cookieai-inc/cookieai-core/agents/custom/dev/cmd/template_setup  -name="$1" -force -skip_lint=false
}

function oaacreateconnector {
    bazel run //clients/oaa/cmd/connector_setup -- -name="$1" -force
}


# Frontend

function fronte2etest {
   cd /Users/Shared/dev/src/github.com/cookieai-inc/cookieai-core/frontend
   npm run record:e2e-be-data; cd -
}

function frontk8senable {
    bazel run //tools/cmd/kubecreate set deploy frontend enable
    bazel run //tools/cmd/kubecreate set build frontend enable
}

function frontk8sdisable {
    bazel run //tools/cmd/kubecreate set deploy frontend disable
    bazel run //tools/cmd/kubecreate set build frontend disable
}

# Kubernetes - performance

function kmem {
   kubectl get namespaces | awk 'NR > 1 { print $1 }' | xargs -I {} bash -c "kubectl -n {} top pod 2>/dev/null | awk 'NR>1{print "'$1" "$3'"}'" | sort -nk2 
}

function kcpu {
   kubectl get namespaces | awk 'NR > 1 { print $1 }' | xargs -I {} bash -c "kubectl -n {} top pod 2>/dev/null | awk 'NR>1{print "'$1" "$2'"}'" | sort -nk2 
}

# DEVTOOLS
function dtupdatedeps {
    bazel run //:gazelle -- update-repos -from_file=go.mod
    bazel run //:gazelle
}
