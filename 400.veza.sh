#!/bin/zsh
alias cdc='cd /Users/Shared/dev/src/github.com/cookieai-inc/cookieai-core'
export CDPATH='/Users/Shared/dev/src/github.com/cookieai-inc/cookieai-core'

function clean_docker() {
    cd /Users/Shared/dev/src/github.com/cookieai-inc/cookieai-core
    bazel run //tools/cmd/dockerclean
    scripts/devenv/start_docker_registry.sh
    bazel run //tools/cmd/kubecreate -- up -t --debug
}
