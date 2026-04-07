#!/bin/bash

iDIR="$HOME/.config/hypr/icons/vol"


#next track
playerctl_next(){
    playerctl next
}

playerctl_previous(){
    playerctl previous
}

playerctl_play_pause(){
    playerctl play-pause
}



# Execute accordingly
if [[ "$1" == "--prev" ]]; then
    playerctl_previous
elif [[ "$1" == "--next" ]]; then
    playerctl_next
else [[ "$1" == "--toggle" ]]; 
    playerctl_play_pause
fi