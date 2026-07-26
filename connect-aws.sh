#!/bin/bash

SSM_HOME_DIRECTORY="$HOME/.aws/config"
printf "–––––––––- List AWS profiles in SSM  –––––––––––\n"
profiles=$(grep '^\[.*\]$' $SSM_HOME_DIRECTORY | tr -d '[]')

printf "Listing AWS Profiles:\n" $profiles

printf "–––––––––-  –––––––––––\n"



