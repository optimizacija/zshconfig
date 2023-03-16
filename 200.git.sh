alias gdc='git diff --cached'
alias gs='git status'

function gdn() {
    git diff --name-only "$@" | cat
}
