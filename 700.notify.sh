function notify() {
    osascript -e 'display notification "Script Finished"'
    afplay "${HOME}/Library/zshrc.d/leviosa.mp3" 
}
