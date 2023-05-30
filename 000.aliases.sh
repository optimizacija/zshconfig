alias h='history'
alias q=exit
alias vim=nvim
alias v=nvim
alias rg='rg --auto-hybrid-regex'
# alias jqfmt='jq -R -r '\''. as $raw | try fromjson catch $raw'\'''
alias jqfmt='jq -R -r '\''. as $raw | try (fromjson | if has("stacktrace") then .stacktrace |= split("\n") else . end) catch $raw'\'''

alias tolower='awk '\''{print tolower($0)}'\'''
alias rgm='rg --multiline --multiline-dotall'

# default editor = nvim
export EDITOR=nvim
