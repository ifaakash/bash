#!/bin/bash

SSM_HOME_DIRECTORY="$HOME/.aws/config"
printf "–––––––––- List AWS profiles in SSM  –––––––––––\n"
aprofiles=$(grep '^\[.*\]$' "$SSM_HOME_DIRECTORY" | tr -d '[]' | sed 's/^profile //')

aselected_profile=$(gum choose $aprofiles)

printf "–––––––––- Connecting to AWS profile  –––––––––––\n"

if aws sts get-caller-identity --profile $aselected_profile  > /dev/null 2>&1; then
   printf "Already logged into the profile ${aselected_profiles}\n Skipping the login step!"
else
   printf "Needs authentication. Opening browser..."
   if  ! aws sso login --profile $aselected_profile; then
       printf "Skipping login due to failure"
       continue
   fi
fi

printf "–––––––––-  –––––––––––\n"
