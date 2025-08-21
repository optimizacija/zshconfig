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
# Load nvm (check both possible locations)
[ -s "/opt/homebrew/opt/nvm/nvm.sh" ] && \. "/opt/homebrew/opt/nvm/nvm.sh"  # Apple Silicon
[ -s "/usr/local/opt/nvm/nvm.sh" ] && \. "/usr/local/opt/nvm/nvm.sh"      # Intel Mac
[ -s "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm" ] && \. "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm"

# npm's global bin directory to your PATH (only after nvm is loaded)
# (to find claude you need this)
export PATH="$(npm config get prefix)/bin:$PATH"
eval "$(rbenv init -)"
