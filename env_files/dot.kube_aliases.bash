# Kubernetes aliases and environment variables

# stop processing on nodes that don't have a ~/.kube.config
#if [[ ! -f $HOME/.kube/config ]]; then return; fi

## Environment variables
export kdc="--dry-run=client -o yaml"
export kds="--dry-run=server -o yaml"

# Determine which flavor of Kubernetes is installed
if [[ -n "$(which k3s)" ]]; then
	## Use k3s
	alias k="sudo k3s kubectl"
	alias kg="sudo k3s kubectl get"
	alias ka="sudo k3s kubectl apply"
	alias kc="sudo k3s kubectl create"
	alias kd="sudo k3s kubectl delete"
	alias kgp="sudo k3s kubectl get pods"
	alias kgs="sudo k3s kubectl get service"
	alias kgn="sudo k3s kubectl get nodes"
	alias kdesc="sudo k3s kubectl describe"
	alias kcuc="sudo k3s kubectl config use-context"

else

	## Standard Kubernetes
	export KUBECONFIG=$HOME/.kube/config
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

fi

## kubevirt
#alias virtctl="kubectl virt --kubeconfig=$KUBECONFIG"
#
## crtctl
#alias crictl="crictl -r unix:///run/containerd/containerd.sock"

