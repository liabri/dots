# add ~/.local/share/.bin to path
export PATH="$(find ~/.local/share/.bin/ -maxdepth 1 -type d | sed 's|/$||'| tr '\n' ':')$PATH"

# add cargo to path
[ -r ~/.cargo/env ] && . ~/.cargo/env

# xdg
export XDG_DESKTOP_DIR="$HOME/.local/share"
export XDG_DOCUMENTS_DIR="$HOME/documents"
export XDG_DOWNLOAD_DIR="$HOME/minzel"
export XDG_MUSIC_DIR="$HOME/music"
export XDG_VIDEOS_DIR="$HOME/videos"
export XDG_PICTURES_DIR="$HOME/pictures"
export XDG_SCREENSHOTS_DIR="$XDG_PICTURES_DIR/screenshots"
export XDG_RECORDINGS_DIR="$XDG_VIDEOS_DIR/recordings"
export XDG_PUBLICSHARE_DIR="$HOME/public"
export XDG_TEMPLATES_DIR="$HOME/.config/templates"
export XDG_VIDEOS_DIR="$HOME/videos"
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_CACHE_HOME="$HOME/.cache"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_STATE_HOME="$HOME/.local/state"

# --- SSH Agent Setup (POSIX shell) ---
SSH_ENV="$HOME/.ssh/agent_env"

# function to start a new ssh-agent
start_agent() {
    echo "Starting new ssh-agent..."
    eval "$(ssh-agent -s)" >/dev/null
    printf 'SSH_AUTH_SOCK=%s\nSSH_AGENT_PID=%s\n' "$SSH_AUTH_SOCK" "$SSH_AGENT_PID" > "$SSH_ENV"
    chmod 600 "$SSH_ENV"
}

# load existing agent if available
if [ -f "$SSH_ENV" ]; then
    . "$SSH_ENV"
    # check if agent is alive
    if [ -n "$SSH_AGENT_PID" ] && kill -0 "$SSH_AGENT_PID" 2>/dev/null; then
        :
    else
        start_agent
    fi
else
    start_agent
fi
# --- End SSH Agent Setup ---
