# Shared zsh environment.
export ZSH_CACHE_DIR="$XDG_CACHE_HOME/zsh"

# Editor and Visuals
export EDITOR="nvim"
export VISUAL="nvim"

# Zsh eval path
fpath+=(
	"$HOME/.config/hcloud/completion/zsh"
)

# User-installed binaries
path+=(
	"$HOME/go/bin"
	"$HOME/.cargo/bin"
	"$HOME/.local/bin"
	"$HOME/.local/share/solana/install/active_release/bin"
	"$HOME/.avm/bin"
	"$HOME/.local/share/nvim/mason/bin"
	$path
)

case "$(uname -s)" in
    Linux*)
	    platform="Linux"
	;;
    Darwin*)
	platform="macOS" 
	path+=(
		"$HOME/homebrew/bin"
		"/opt/homebrew/bin"
		"/opt/homebrew/opt/libpq/bin"
	)
	;;
    *)
	    platform="Unknown" ;;
esac
