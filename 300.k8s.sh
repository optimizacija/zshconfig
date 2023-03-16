#!/bin/zsh
# package manager
export PATH="${PATH}:${HOME}/.krew/bin"

# for ksniff plugin
alias wireshark="/Applications/Wireshark.app/Contents/MacOS/Wireshark"

# useful aliases
alias k=kubectl

# Drop into an interactive terminal on a container
alias keti='kubectl exec -ti'

# Manage configuration quickly to switch contexts between local, dev ad staging.
alias kcu='kubectl config use-context'
alias kcs='kubectl config set-context'
alias kcd='kubectl config delete-context'
alias kcc='kubectl config current-context'
alias kcg='kubectl config get-contexts'

# Pod management.
alias kgp='kubectl get pods'
alias kgpw='kgp --watch'
alias kgpwide='kgp -o wide'
alias kep='kubectl edit pod'
alias kdp='kubectl describe pods'
alias kdelp='kubectl delete pods'
# get pod by label: kgpl "app=myapp" -n myns
alias kgpl='kgp -l'
function kgpa {
    kubectl get pods -l app="$1"
}

# Service management.
alias kgsvc='kubectl get svc'
alias kgsvcw='kgsvc --watch'
alias kgsvcwide='kgsvc -o wide'
alias kesvc='kubectl edit svc'
alias kdsvc='kubectl describe svc'
alias kdelsvc='kubectl delete svc'

# Secret management
alias kgs='kubectl get secret'
alias kgsjson='kubectl get secret -o json'
alias kds='kubectl describe secret'

# Deployment management.
alias kgd='kubectl get deployment'
alias kgdw='kgd --watch'
alias kgdwide='kgd -o wide'
alias ked='kubectl edit deployment'
alias kdd='kubectl describe deployment'
alias kdeld='kubectl delete deployment'
alias ksd='kubectl scale deployment'
alias krsd='kubectl rollout status deployment'

# Port forwarding
alias kpf="kubectl port-forward"

# Logs
alias kl='kubectl logs'
alias klf='kubectl logs -f'
alias klft='kubectl logs -f --tail 50'
# logs for all pods of the same service
function klfa {
    kubectl logs -f --ignore-errors -l app="$1" -c "$1"
}
function klfta {
    kubectl logs -f --tail 50 --ignore-errors -l app="$1" -c "$1"
}

# File copy
alias kcp='kubectl cp'

# Node Management
alias kgno='kubectl get nodes'
alias keno='kubectl edit node'
alias kdno='kubectl describe node'
alias kdelno='kubectl delete node'

# CronJob management.
alias kgcj='kubectl get cronjob'
alias kecj='kubectl edit cronjob'
alias kdcj='kubectl describe cronjob'
alias kdelcj='kubectl delete cronjob'
