# Lapav
Window manager independent script to hide/unhide windows

## Why though
I recently tried awesome wm and it has this neat feature of when click on window's
title it will hide the window. Really good feature and I wanted this on my bspwm setup too
(To make work flow across WMs consistent). So I thought of writing a script which is WM agnostic

# Requirements
- xdo
- xdotool
- rofi or dmenu

```sh
# For debian based distro
sudo apt install xdo xdotool rofi

# For arch based distro
sudo pacman -S --needed xdo xdotool rofi

# For void linux based distro
sudo xbps-install -S xdo xdotool rofi
```

# Installation
```sh
curl https://raw.githubusercontent.com/shubham-cpp/lapav/main/lapav.sh > ~/.local/bin/lapav
# Make sure ~/.local/bin is in your $PATH
chmod +x ~/.local/bin/lapav
```
# Example
```sh
lapav hide # if nothing is passed then it will hide the focused window

lapav show # if nothing is passed then it will show the last hidden window

lapav hide select # This will lauch rofi and let you select a window to hide
lapav show select # This will lauch rofi and let you select a window to be shown
```
### For bspwm add this to your ~/.config/sxhkd/sxhkdrc
```sh
super + {_,shift + } h
    lapav {hide,hide select}

super + {_,shift + } s
    lapav {show,show select}
```
### For other desktop
You know better than me

# Todos

- [ ] Make this posix compliant
- [ ] Optimize the Script
- [ ] Maybe rewrite in a programming lang like C or Go to eliminate xdo and xdotool dependency
- [ ] xdotool man page has an option of selectwindow which provide a functionality to select a window via mouse click. Interesting
- [ ] Add A video example
- [ ] Add option to list windows from all workspaces

# FAQs
## 1. Weird name
    Hide in marathi(my native language) is called lapav
## 2. Will this work on XYZ Window manager
    Yes. If you have the Requirements then this will work.
## 3. When will todos be completed
    My exams start from Friday so really cant say anything concrete
