#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
alias ll='ls -al'
PS1='[\u@\h \W]\$ '

# Define vim as the default text editor
VISUAL=vim
export VISUAL 
EDITOR=vim
export EDITOR

# Go to home directory if using dotfiles directory
if [[ "$PWD" = *"/dotfiles" ]]; then
  cd $HOME
fi
