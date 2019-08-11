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
    for dotfile in "$(ls -pd ${DIR}/.!(|.) | egrep -v /$)"; do
        dotfilename="$(basename ${dotfile})"
        dotfilelink="${HOME}/${dotfilename}"
        ln -sf "${dotfile}" "$dotfilelink"
        echo "> Created $dotfilelink"
    done

    # .config dotfiles
    for dotfile in "$(ls -pd ${DIR}/.config/* | egrep -v /$)"; do
        dotfilename="$(basename ${dotfile})"
        dotfilelink="${HOME}/.config/${dotfilename}"
        ln -sf "${dotfile}" "$dotfilelink"
        echo "> Created $dotfilelink"
    done

    # .config directories
    for dotfile in "$(ls -pd ${DIR}/.config/* | egrep /$)"; do
        ln -sf "${dotfile}" "${HOME}/.config"
        echo "> Created ${HOME}/.config/$(basename ${dotfile})"
    done

    echo "> Symbolic links created successfully!"

    return 0
}

install_packages() {
    echo "> Installing packages..."

    while true; do
        read -p "> Choose which video driver to install (1: Intel, 2: AMD, 3: Nvidia): " vd
        case $vd in
            1) videodriver="xf86-video-intel vulkan-intel lib32-vulkan-intel"; break;;
            2) videodriver="xf86-video-amdgpu vulkan-radeon lib32-vulkan-radeon"; break;;
            3) videodriver="nvidia nvidia-utils lib32-nvidia-utils nvidia-settings"; break;;
            *) echo "> Invalid Input";;
        esac
    done

    package_list=$(get_packages "${DIR}/package-list")

    sudo pacman -Syy

    sudo pacman -S $package_list $videodriver

    setup_aur

    package_list_aur=$(get_packages "${DIR}/package-list-aur")

    yay -S $package_list_aur

    echo "> Packages installed successfully!"

    return 0
}

get_packages() {
    packages=""

    while read -r line; do
        if [[ "${#line}" -gt 0 ]] && [[ ! "${line}" =~ "#" ]]; then
            packages="${packages} ${line}"
        fi
    done < $1

    echo $packages

    return 0
}

setup_aur() {
    rm -rf yay
    
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

    echo "> Keymap set successfully!"

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
