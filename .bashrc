#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
PS1='[\u@\h \W]\$ '

# Define vim as the default text editor
VISUAL=vim
export VISUAL 
EDITOR=vim
export EDITOR

# Import pywal theme
cat ~/.cache/wal/sequences
