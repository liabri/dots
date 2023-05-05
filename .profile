export PATH="$(find ~/.bin/ -maxdepth 1 -type d | sed 's|/$||'| tr '\n' ':')$PATH"

export XDG_DESKTOP_DIR="$HOME/.local/share"
export XDG_DOCUMENTS_DIR="$HOME/dokumenti"
export XDG_DOWNLOAD_DIR="$HOME/minzel"
export XDG_MUSIC_DIR="$HOME/muzika"
export XDG_VIDEOS_DIR="$HOME/film"
export XDG_PICTURES_DIR="$HOME/ritratti"
export XDG_SCREENSHOTS_DIR="$XDG_PICTURES_DIR/fotoskermi"
export XDG_RECORDINGS_DIR="$XDG_VIDEOS_DIR/cqieli"
export XDG_PUBLICSHARE_DIR="$HOME/pubbliku"
export XDG_TEMPLATES_DIR="$HOME/.config/mudelli.tal-filzi"
export XDG_VIDEOS_DIR="$HOME/videos"
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_CACHE_HOME="$HOME/.cache"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_STATE_HOME="$HOME/.local/state"

# temporary for wayland
export MOZ_ENABLE_WAYLAND=1

# locale
export LANG="en_US.utf8"
export LC_CTYPE="en_US.utf8"
export LC_NUMERIC="en_US.utf8"
export LC_TIME="en_US.utf8"
export LC_COLLATE="en_US.utf8"
export LC_MONETARY="en_US.utf8"
export LC_MESSAGES="en_US.utf8"
export LC_PAPER="en_US.utf8"
export LC_NAME="en_US.utf8"
export LC_ADDRESS="en_US.utf8"
export LC_TELEPHONE="en_US.utf8"
export LC_MEASUREMENT="en_US.utf8"
export LC_IDENTIFICATION="en_US.utf8"
export LC_ALL="en_US.utf8"

# for games
export SDL_VIDEODRIVER=wayland