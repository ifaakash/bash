#!/bin/bash

SSM_HOME_DIRECTORY="$HOME/.aws/config"
printf "–––––––––- List AWS profiles in SSM  –––––––––––\n"
profiles=$(grep '^\[.*\]$' "$SSM_HOME_DIRECTORY" | tr -d '[]' | sed 's/^profile //')

selectedProfile=$(gum choose $profiles)

printf "–––––––––- Connecting to AWS profile  –––––––––––\n"

if ! aws sts get-caller-identity --profile $selectedProfile  > /dev/null 2>&1; then
   printf "Already logged into the profile ${selectedProfile}\n Skipping the login step!"
else
   printf "Needs authentication. Opening browser..."
   if  ! aws sso login --profile $selectedProfile; then
       printf "Skipping login due to failure"
       continue
   else
       printf "Connect to AWS account via $selectedProfile profile"
   fi
fi

printf "–––––––––- LISTING EC2 Instances  –––––––––––\n"
availableRegion=("us-east-1" "us-east-2")
region=$(gum choose ${availableRegion[@]})
printf "Setting $region as default region for all AWS commands for this session\n"
# export "AWS_REGION"=$region
# aws ec2 describe-instances --region ap-south-1


