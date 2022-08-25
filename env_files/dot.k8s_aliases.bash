# Kubernetes aliases and environment variables

# stop processing on nodes that don't have a ~/.kube.config
#if [[ ! -f $HOME/.kube/config ]]; then return; fi

##
## Environment variables
export kdc="--dry-run=client -o yaml"
export kds="--dry-run=server -o yaml"
export KUBECONFIG=$HOME/.kube/config

##
## Kubernetes
alias k="kubectl"
alias kg="kubectl get"
alias ka="kubectl apply"
alias kc="kubectl create"
alias kd="kubectl delete"
alias kgp="kubectl get pods"
alias kgs="kubectl get service"
alias kgn="kubectl get nodes"
alias kdesc="kubectl describe"

alias kcuc="kubectl config use-context"
#alias kcn="k config set-context $(kubectl config current-context) --namespace"

# kubevirt
alias virtctl="kubectl virt --kubeconfig=$KUBECONFIG"

# crtctl
alias crictl="crictl -r unix:///run/containerd/containerd.sock"


