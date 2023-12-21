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
# bazel gen pipeline configuration (pipeline_configuration.generated.json)
alias bazgenpipelinecfg='bazel run //agents/dev/cmd/cfggenerator'

# bazel clean docker
function bazcleandocker() {
    bazel run //tools/cmd/dockerclean
    scripts/devenv/start_docker_registry.sh
    bazel run //tools/cmd/kubecreate -- up -t --debug
}

function bazhardcleandocker() {
    bazel run //tools/cmd/dockerclean
    docker ps -a | awk 'NR > 1 {print $1}' | xargs -I {} docker kill {} 2&>/dev/null 
    docker system prune -f 
    docker volume prune -f
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

function stern_logs {
    stern -n tenant1-cp --color=always '.*' 2>&1
}

function stern_logs_fmt {
   stern -n tenant1-cp '.*' --color=always 2>&1 |\
       awk '{ print $1 " " $2; $1=$2=""; sub(/^ */, ""); print $0; }' | \
       jq -R -r '. as $raw | try (fromjson | if has("ts") then .ts |= strftime("%Y-%m-%d %H:%M:%S") else . end) catch $raw'
}

function stern_error_logs {
    stern -n tenant1-cp --color=always '.*' 2>&1 | grep '"level":"error"'
}

function bazgenpermap {
   bazel run //agents/azure/permap/cmd/genpermap 
}

function bazoaaextract {
    bazel run //agents/dev/cmd/agentrunner extract custom_provider_application
}

function oaacreatetemplate {
    go run github.com/cookieai-inc/cookieai-core/agents/custom/dev/cmd/template_setup  -name="$1" -force -skip_lint=false
}

function oaacreateconnector {
    bazel run //clients/oaa/cmd/connector_setup -- -name="$1" -force
}
