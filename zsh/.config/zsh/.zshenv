# Shared zsh environment.
export ZSH_CACHE_DIR="$XDG_CACHE_HOME/zsh"

# Visuals
export EDITOR="nvim"
export VISUAL="nvim"

# Kubectl clusters
export KUBECONFIG="$HOME/Projects/notbet/terraform-hcloud-kube-hetzner/cluster-1/cluster-1_kubeconfig.yaml"

# User-installed binaries
path=("$HOME/go/bin" "$HOME/.cargo/bin" $path)
