#!/usr/bin/env bash

RED=$(tput setaf 1)
GREEN=$(tput setaf 2)
YELLOW=$(tput setaf 11)
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
    xdotool windowminimize --sync "$wid"
}

pop() {
    tmp=$(mktemp)
    wid=$1
    xdotool windowactivate $wid || $(echo "$RED Failed $NC" && exit 1)
    head -n-1 $stack > $tmp
    mv $tmp $stack
}

usage() {

## For Colored output looking into this
## Black        0;30     Dark Gray     1;30
## Red          0;31     Light Red     1;31
## Green        0;32     Light Green   1;32
## Brown/Orange 0;33     Yellow        1;33
## Blue         0;34     Light Blue    1;34
## Purple       0;35     Light Purple  1;35
## Cyan         0;36     Light Cyan    1;36
## Light Gray   0;37     White         1;37

cat << EOF
Usage:
 $YELLOW $0 $GREEN [hide|show] [select]
  $YELLOW Options:$NC
    $GREEN hide:$NC Hide option will hide the window, if no arguement is provided
            then current focused window will be hidden
    $GREEN show:$NC This option will show the window. If no arguement is provided
            then the last hidden window will be show
  $YELLOW Args:$NC
    $GREEN select:$NC This option will launch rofi or dmenu(which is installed)
            and show the list of windows to perform operation
            (like hide or show)
EOF
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
        # printf "$RED Please provide an argument!! $NC\n hide or show\n"
        # exit 1
        usage
        ;; # unknown arg
esac
