# DistroTube

# Changing "ls" to "exa"
alias ls='exa -a --color=always --group-directories-first'  # all files and dirs
alias la='exa -alh --color=always --group-directories-first' # my preferred listing
alias ll='exa -lh --color=always --group-directories-first'  # long format
alias lt='exa -aT --color=always --group-directories-first' # tree listing
alias l.='exa -a | egrep "^\."'
