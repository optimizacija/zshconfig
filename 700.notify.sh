function notify() {
    if [ $? -eq 0 ]; then
      say "success!"
    else
      say "error!"
    fi
}
