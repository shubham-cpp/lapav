#!/usr/bin/env bash

RED=$(tput setaf 1)
GREEN=$(tput setaf 2)
NC=$(tput sgr 0)

delim=":"
stack=/tmp/win_hide

die(){
    [ ! -s $stack ] && notify-send "Empty File" "No window is hidden" && exit 1
}

cmd=$([ -f /usr/bin/rofi ] && echo "rofi -dmenu -matching fuzzy" || echo "dmenu -i -l 10")

push() {
    [ -z "$1" ] && exit 1
    wid="$1"
    # Add window id only if it doesn't exist
    grep -qxF "$1" "$stack" || printf "%s:%s\n" "$wid" "$(xdotool getwindowname $wid)" >> $stack
    xdotool windowunmap --sync "$wid"
}

pop() {
    tmp=$(mktemp)
    wid=$1
    xdotool windowmap $wid || $(echo "$RED Failed $NC" && exit 1)
    head -n-1 $stack > $tmp
    mv $tmp $stack
}

case $1 in
    hide)
        if [ -z "$2" ]; then
            # no arguement provide to hide focused window
            push "$(xdotool getwindowfocus)"
        else
            if [ "$2" = "select" ]; then
                win_names=$(xdo id -d | xargs -r -I{} sh -c 'printf "%s:%s\n" {} "$(xdotool getwindowname {})"')
                wid=$(echo "$win_names" | eval "$cmd" | cut -d':' -f1)
                push "$wid"
            else
                printf "$RED please provide right arguements.\n$NC Did you mean$GREEN select $NC \n"
                exit 1
            fi
        fi
        ;;
    show)

        die
        if [ -z "$2" ]; then
            # No arguement is provide to unhide last window
            wid=$(tail < $stack -n1 | cut -d':' -f1)
            pop $wid
        else
            if [ "$2" = "select" ]; then
                wid=$(cat $stack | eval "$cmd" | cut -d':' -f1)
                pop "$wid"
            else
                printf "$RED please provide right arguements.\n$NC Did you mean$GREEN select $NC \n"
                exit 1
            fi
        fi

        ;;
    *)
        printf "$RED Please provide an argument!! $NC\n hide or show\n"
        exit 1
        ;; # unknown arg
esac

## For Colored output looking into this
## Black        0;30     Dark Gray     1;30
## Red          0;31     Light Red     1;31
## Green        0;32     Light Green   1;32
## Brown/Orange 0;33     Yellow        1;33
## Blue         0;34     Light Blue    1;34
## Purple       0;35     Light Purple  1;35
## Cyan         0;36     Light Cyan    1;36
## Light Gray   0;37     White         1;37

# then use tput. 1 means red, 2 means green ,etc
## tput setaf 1; echo "this is red text"

# usage() {
# cat << EOF
# Usage:
#   $0 [-u [username]] [-p]
#   Options:
#     -u <username> : Optionally specify the new username to set password for.
#     -p : Prompt for a new password.
# EOF
# }
