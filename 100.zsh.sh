export ZSH="${HOME}/.oh-my-zsh"
ZSH_THEME="oxide"

plugins=(
    git
    docker
    zsh-syntax-highlighting
)

source $ZSH/oh-my-zsh.sh

update() {
    local brew="brew update; brew upgrade;"
    sh -c $brew
}

man() {
    env \
        LESS_TERMCAP_mb=$(printf "\e[1;31m") \
        LESS_TERMCAP_md=$(printf "\e[1;31m") \
        LESS_TERMCAP_me=$(printf "\e[0m") \
        LESS_TERMCAP_se=$(printf "\e[0m") \
        LESS_TERMCAP_so=$(printf "\e[1;44;33m") \
        LESS_TERMCAP_ue=$(printf "\e[0m") \
        LESS_TERMCAP_us=$(printf "\e[1;32m") \
        man "$@"
}
