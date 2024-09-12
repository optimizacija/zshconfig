alias gdc='git diff --cached'
alias gs='git status'

function gdn() {
    git diff --name-only "$@" | cat
}

# git find (commit before) timestamp
function gft() {
    git rev-list -1 --before="$1" HEAD
}
