#!/usr/bin/env bash

DIR="${HOME}/Documents/GitHub/dotfiles"

DOTFILES=(".bashrc" ".Xresources")

#ln -sf "${DIR}/Wallpaper.jpg" "${HOME}/Pictures/Wallpaper.jpg"

for dotfile in "${DOTFILES[@]}"; do
    ln -sf "${DIR}/${dotfile}" "${HOME}/${dotfile}"
done
