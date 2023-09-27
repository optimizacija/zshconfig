# load personal scripts that start with a number prefix
CONF_PATH="${HOME}/Library/zshrc.d/"
for file in $(find "$CONF_PATH" -type f -regex '.*/[0-9].*\.sh'); do
    source "$file"
done

# TODO: delete these 2 lines, after you make sure are not neccessary: 27. 9. 2023
# Add RVM to PATH for scripting. Make sure this is the last PATH variable change.
# export PATH="$PATH:$HOME/.rvm/bin"

# go extension libraries
export PATH="$PATH:$(go env GOPATH)/bin"

export NVM_DIR="$HOME/.nvm"
[ -s "/opt/homebrew/opt/nvm/nvm.sh" ] && \. "/opt/homebrew/opt/nvm/nvm.sh"  # This loads nvm
[ -s "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm" ] && \. "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm"  # This loads nvm bash_completion
