#!/bin/bash

case $1 in
    "main")
        firefox 
        ;;
    "school")
        google-chrome-stable --profile-directory="Profile 4" --ozone-platform-hint=auto
        ;;
    "tutor")
        google-chrome-stable --profile-directory="Profile 3" --ozone-platform-hint=auto
        ;;
esac