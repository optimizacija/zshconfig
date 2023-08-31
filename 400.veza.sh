#!/bin/zsh
alias cdc='cd /Users/Shared/dev/src/github.com/cookieai-inc/cookieai-core'
export CDPATH='/Users/Shared/dev/src/github.com/cookieai-inc/cookieai-core'
alias bazel_run_record='bazel run --config=record'
alias bazel_run_record_skip_extraction='bazel run --config=record --define=skip_test_extraction=true'
alias bazel_lint_fix='bazel run //tools:lint go -- --fix'
alias bazel_gen_proto='bazel run //tools:genproto'
alias bazel_gen_wildcard_edges='bazel run //controlp/internal/graph/cmd/genwildcardedges -- -output `realpath internal/graph_schema/wildcard_edges.go`'

function clean_docker() {
    bazel run //tools/cmd/dockerclean
    scripts/devenv/start_docker_registry.sh
    bazel run //tools/cmd/kubecreate -- up -t --debug
}

function bazel_genreachability_fingerprint {
    bazel run //controlp/internal/graph/cmd/genreachability -- \
        -output-reachability-fingerprint `realpath controlp/internal/graph/precomputed_reachability_fingerprint.txt` \
        -output-reachability `realpath controlp/internal/graph/precomputed_reachability_map.go` \
        -output-graphplanner `realpath controlp/internal/graph/graphplanner`
}

function bazel_upgrade_tenant {
    bazel run //tools/cmd/kubecreate -- tenant upgrade -n tenant1 
}

function bazel_gen_nodelist {
    bazel run //internal/graph_schema/cmd/nodelist -- -graph-level=ALL -output `realpath frontend/scripts/NodeTypes.json`
}

function count_manual_changes {
    # $1: master
    # $2: head
    # master..head
    git diff --stat "$1".."$2" ':!*.json' ':!*.pb.go' ':!*.bazel' ':!*.copyist' ':!*tar.gz' | sed -nE 's/.*\| *([0-9]+).*/\1/p' | awk '{s+=$1} END {print s}'
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

