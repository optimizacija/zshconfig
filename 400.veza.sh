#!/bin/zsh
alias cdc='cd /Users/Shared/dev/src/github.com/cookieai-inc/cookieai-core'
export CDPATH='/Users/Shared/dev/src/github.com/cookieai-inc/cookieai-core'
# bazel run
alias bazn='bazel run'
# bazel record
alias bazrec='bazel run --config=record'
# bazel record and skip extraction
alias bazrecskip='bazel run --config=record --define=skip_test_extraction=true'
# bazel run lint go fix
alias bazlintfix='bazel run //tools:lint go -- --fix'
# bazel gen proto files
alias bazgenproto='bazel run //tools:genproto'
# bazel gen wildcard edges
alias bazgenwcedges='bazel run //controlp/internal/graph/cmd/genwildcardedges -- -output `realpath internal/graph_schema/wildcard_edges.go`'

# bazel clean docker
function bazcleand() {
    bazel run //tools/cmd/dockerclean
    scripts/devenv/start_docker_registry.sh
    bazel run //tools/cmd/kubecreate -- up -t --debug
}

# bazel gen (reachability) fingerprint
function bazgenfp {
    bazel run //controlp/internal/graph/cmd/genreachability -- \
        -output-reachability-fingerprint `realpath controlp/internal/graph/precomputed_reachability_fingerprint.txt` \
        -output-reachability `realpath controlp/internal/graph/precomputed_reachability_map.go` \
        -output-graphplanner `realpath controlp/internal/graph/graphplanner`
}

# bazel ugprade tenant
function bazut {
    bazel run //tools/cmd/kubecreate -- tenant upgrade -n tenant1 
}

# bazel gen node list
function bazgennl {
    bazel run //internal/graph_schema/cmd/nodelist -- -graph-level=ALL -output `realpath frontend/scripts/NodeTypes.json`
}

function count_manual_changes {
    # $1: master
    # $2: head
    # master..head
    git diff --stat "$1".."$2" ':!*.json' ':!*.pb.go' ':!*.bazel' ':!*.copyist' ':!*tar.gz' ':!*.bzl' | sed -nE 's/.*\| *([0-9]+).*/\1/p' | awk '{s+=$1} END {print s}'
}

function kpf_neo4j {
   kubectl port-forward -n tenant1-cp cp-neo4j-historical-0 7687:7687 7474:7474 
}

function stern_error_logs {
    stern -n tenant1-cp --color=always '.*' 2>&1 | grep '"level":"error"'
}

function stern_error_logs_jq {
    # prettified
   stern -n tenant1-cp '.*' --color=always 2>&1 |\
       grep '"level":"error"' |\
       awk '{ print $1 " " $2; $1=$2=""; sub(/^ */, ""); print $0 | "jq ."; close("jq ."); }' 
}

