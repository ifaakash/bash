#!/bin/bash

SSH_DIRECTORY="$HOME/.ssh"

printf "–––––––––- Listing SSH directory for all keys –––––––––––\n"
list=$(ls $SSH_DIRECTORY)

printf "Choose the ssh key to add:\n"
key_name=$(gum choose $list)

if [ $key_name == '']; then
  printf "––––––––– EXITING - no key selected –––––––––"
  break
else
	printf "Initialising new ssh agent\n"
	eval "ssh-agent -s"
	 
	printf "Adding ssh key $key_name"
	ssh-add $SSH_DIRECTORY/$key_name
fi
