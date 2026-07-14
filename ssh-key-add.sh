#!/bin/bash

SSH_DIRECTORY="$HOME/.ssh"

printf "–––––––––- Listing SSH directory for all keys –––––––––––\n"
ls $SSH_DIRECTORY

printf "Enter the name of ssh key to add:\n"
read key_name

printf "Initialising new ssh agent\n"
eval "ssh-agent -s"

printf "Adding ssh key $key_name"
ssh-add $SSH_DIRECTORY/$key_name
