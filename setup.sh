#!/usr/bin/env bash

# Personal system setup script

# repository path
DIR="$(dirname $(realpath $0))"

create_symlinks() {
    echo "> Creating symbolic links..."

    # wallpaper
    wallpaperlink="${HOME}/Pictures/Wallpaper.jpg"
    ln -sf "${DIR}/Wallpaper.jpg" "$wallpaperlink"
    echo "> Created $wallpaperlink"

    # home dotfiles
    DOTFILES1=(".bash_profile" ".bashrc" ".gtkrc-2.0" ".rtorrent.rc" ".vimrc" ".xinitrc" ".Xresources")

    for dotfile in "${DOTFILES1[@]}"; do
        dotfilelink="${HOME}/${dotfile}"
        ln -sf "${DIR}/${dotfile}" "$dotfilelink"
        echo "> Created $dotfilelink"
    done

    # .config dotfiles
    DOTFILES2=("compton.conf" "user-dirs.dirs")

    for dotfile in "${DOTFILES2[@]}"; do
        dotfilelink="${HOME}/.config/${dotfile}"
        ln -sf "${DIR}/.config/${dotfile}" "$dotfilelink"
        echo "> Created $dotfilelink"
    done

    # .config directories
    DOTFILES3=("dunst" "gtk-3.0" "i3" "neofetch" "polybar" "ranger" "rofi")

    for dotfile in "${DOTFILES3[@]}"; do
        ln -sf "${DIR}/.config/${dotfile}" "${HOME}/.config"
        echo "> Created ${HOME}/.config/${dotfile}"
    done

    echo "> Symbolic links successfully created!"

    return 0
}

install_packages() {
    echo "> Installing packages..."

    while true; do
        read -p "> Choose which video driver to install (1: Intel, 2: AMD, 3: Nvidia): " vd
        case $vd in
            1) videodriver="xf86-video-intel"; break;;
            2) videodriver="xf86-video-ati"; break;;
            3) videodriver="nvidia nvidia-utils lib32-nvidia-utils"; break;;
            *) echo "> Invalid Input";;
        esac
    done

    sudo pacman -S $videodriver 

    setup_aur

    yay -S 

    echo "> Packages successfully installed..."

    return 0
}

setup_aur() {
    git clone https://aur.archlinux.org/yay.git

    cd yay

    makepkg -si

    cd ..

    rm -rf yay

    return 0
}

set_keymap() {
    read -p "> Choose keymap region: " keyregion
    
    localectl set-x11-keymap "$keyregion"

    return 0
}

main() {
    echo "> Starting setup..."

    while true; do
        read -p "> Create symbolic links? [Y/n] " sl
        case $sl in
            [Yy]*) create_symlinks; break;;
            "") create_symlinks; break;;
            [Nn]*) break;;
            *) echo "> Invalid Input";;
        esac
    done

    while true; do
        read -p "> Run package install? [Y/n] " pi
        case $pi in
            [Yy]*) install_packages; break;;
            "") install_packages; break;;
            [Nn]*) break;;
            *) echo "> Invalid Input";;
        esac
    done

    while true; do
        read -p "> Setup X.org keymap? [Y/n] " xk
        case $xk in
            [Yy]*) set_keymap; break;;
            "") set_keymap; break;;
            [Nn]*) break;;
            *) echo "> Invalid Input";;
        esac
    done

    while true; do
        read -p "> Setup user directories? [Y/n] " ud
        case $ud in
            [Yy]*) xdg-user-dirs-update; break;;
            "") xdg-user-dirs-update; break;;
            [Nn]*) break;;
            *) echo "> Invalid Input";;
        esac
    done

    echo "> Setup finished successfully!"

    return 0
}

main "$@"
