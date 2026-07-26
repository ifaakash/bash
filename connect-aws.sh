#!/bin/bash

SSM_HOME_DIRECTORY="$HOME/.aws/config"
printf "–––––––––- List AWS profiles in SSM  –––––––––––\n"
aprofiles=$(grep '^\[.*\]$' "$SSM_HOME_DIRECTORY" | tr -d '[]' | sed 's/^profile //')

aselected_profile=$(gum choose $profiles)

printf "–––––––––- Connecting to AWS profile  –––––––––––\n"
aws sso login --profile $aselected_profiles

printf "–––––––––-  –––––––––––\n"



