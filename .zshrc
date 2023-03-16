export HISTSIZE=100000

ZSH_THEME="powerlevel10k/powerlevel10k"

# load personal scripts
CONF_PATH="${HOME}/Library/zshrc.d/"
for FN in $CONF_PATH/*; do
    # if file, directly source it
    if [ -f "$FN" ]; then
        source "$FN"
    fi

    # if directory, make sure the name of the directory
    # is an existing command - if so, source files in directory
    if [ -d "${FN}" ]; then
        CMD=$(echo "$FN" | awk '{n=split($1,A,"/"); print A[n]}')

        if which "$CMD" >/dev/null 2>&1; then
            for DEPFN in $FN/*; do
                source "$DEPFN"
            done
        fi
    fi
done

# node version manager
export NVM_DIR="$HOME/.nvm"
[ -s "/usr/local/opt/nvm/nvm.sh" ] && . "/usr/local/opt/nvm/nvm.sh"
# bash completion for nvm
[ -s "/usr/local/opt/nvm/etc/bash_completion.d/nvm" ] && . "/usr/local/opt/nvm/etc/bash_completion.d/nvm"

# Add RVM to PATH for scripting. Make sure this is the last PATH variable change.
export PATH="$PATH:$HOME/.rvm/bin"

# go extension libraries
export PATH="$PATH:$(go env GOPATH)/bin"

# Load Angular CLI autocompletion.
source <(ng completion script)
