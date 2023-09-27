#!/bin/zsh

function createOnce {
    currDir=$(pwd)
    destinationFilePath="$HOME/$1"
    
    if [ -e "$destinationFilePath" ]; then
        if [ ! -L "$destinationFilePath" ]; then
            echo "Failed to create symbolic link for $1. File already exists">&2
        fi
    else 
        sourceFilePath="$currDir/$1"
        ln -sf "$sourceFilePath" "$destinationFilePath"
    fi 
}

createOnce .jq
createOnce .zshrc
