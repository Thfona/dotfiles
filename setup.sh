#!/usr/bin/env bash

# Personal system setup script

# repository path
DIR="$(dirname $(realpath $0))"

create_symlinks() {
    echo "> Creating symbolic links..."

    # home dotfiles
    for dotfile in "$(ls -pd ${DIR}/.!(|.) | egrep -v /$)"; do
        dotfile_name="$(basename ${dotfile})"
        dotfile_link="${HOME}/${dotfile_name}"

        ln -sf "${dotfile}" "$dotfile_link"

        echo "> Created $dotfile_link"
    done

    # .config dotfiles
    for dotfile in "$(ls -pd ${DIR}/.config/* | egrep -v /$)"; do
        dotfile_name="$(basename ${dotfile})"
        dotfile_link="${HOME}/.config/${dotfile_name}"

        ln -sf "${dotfile}" "$dotfile_link"

        echo "> Created $dotfile_link"
    done

    # .config directories
    for dotfile in "$(ls -pd ${DIR}/.config/* | egrep /$)"; do
        ln -sf "${dotfile}" "${HOME}/.config"

        echo "> Created ${HOME}/.config/$(basename ${dotfile})"
    done

    echo "> Symbolic links created successfully!"

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

    sudo pacman -S --needed git base-devel
    
    git clone https://aur.archlinux.org/yay.git

    cd yay

    makepkg -si

    cd ..

    rm -rf yay

    return 0
}

install_packages() {
    echo "> Installing packages..."

    package_list=$(get_packages "${DIR}/package-list")

    sudo pacman -Syy

    sudo pacman -S $package_list

    setup_aur

    package_list_aur=$(get_packages "${DIR}/package-list-aur")

    yay -S $package_list_aur

    echo "> Packages installed successfully!"

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

    echo "> Setup finished successfully!"

    return 0
}

main "$@"
