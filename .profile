export EDITOR=nvim
export PATH="$(find ~/bin/ -maxdepth 1 -type d | sed 's|/$||'| tr '\n' ':')$PATH"
export PS1="\[\033[01;35m\]\u\033[01;37m\] \W\[\033[01;35m\] \$\[\033[00m\] "
export GTK_THEME=oomox-sage
export QT_QPA_PLATFORMTHEME=qt5ct

export XDG_CACHE_HOME="${HOME}/var/cache"
export XDG_DESKTOP_DIR='/non/existent'
export XDG_DOWNLOAD_DIR="${HOME}/var/downloads"
export MAIL="${HOME}/var/mail/inbox"

