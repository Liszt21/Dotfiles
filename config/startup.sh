echo "Startup"

# use with tmux : tmux new -d -s startup -n main sh ./startup.sh

tmux new-window -d -n picom picom --config ~/Dotfiles/config/picom/picom.conf

tmux new-window -d -n polybar polybar --config=~/Dotfiles/config/polybar/polybar

wal -i ~/Sync/Wallpapers
