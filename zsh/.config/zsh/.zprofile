# Keep this file small: every zsh invocation reads it, including scripts.
export XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"
export XDG_DATA_HOME="${XDG_DATA_HOME:-$HOME/.local/share}"
export XDG_CACHE_HOME="${XDG_CACHE_HOME:-$HOME/.cache}"
export ZSH_CACHE_DIR="$XDG_CACHE_HOME/zsh"
export ZDOTDIR="${ZDOTDIR:-$XDG_CONFIG_HOME/zsh}"

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
)

case "$(uname -s)" in
    Linux*)
	    platform="Linux"
	;;
    Darwin*)
	platform="macOS" 
	path=(
		"$HOME/homebrew/bin"
		"/opt/homebrew/bin"
		"/opt/homebrew/opt/libpq/bin"
		$path
	)
	;;
    *)
	    platform="Unknown" ;;
esac
