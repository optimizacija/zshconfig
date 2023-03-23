alias h='history'
alias q=exit
alias vim=nvim
alias v=nvim
alias rg='rg --auto-hybrid-regex'
alias jqfmt='jq -R -r '\''. as $raw | try fromjson catch $raw'\'''
alias tolower='awk '\''{print tolower($0)}'\'''

# default editor = nvim
export EDITOR=nvim
