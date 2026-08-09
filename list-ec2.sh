#!/bin/bash

printf "–––––––––- LISTING EC2 Instances  –––––––––––\n"
availableRegion=("us-east-1" "us-east-2")
printf "Setup the required environment variables..."
source .env.sh
region=$(gum choose ${availableRegion[@]})
printf "Setting $region as default region for all AWS commands for this session\n"

# export "AWS_REGION"=$region
selectedInstance=$(aws ec2 describe-instances \
    --query 'Reservations[].Instances[].[InstanceId, Tags[?Key==`Name`]|[0].Value]' \
    --region "$region" --profile particle --output text \
    | gum filter --header "Choose an EC2 instance:" \
    | awk '{print $1}')

# printf "Selected instance: %s\n" "$selectedInstance"
printf "Starting SSM session to instance $selectedInstance\n"
# Fetch state of instance
# Provide option to on/off the instance - if on, then off and vice-versa
#aws ssm start-session --target $selectedInstance --region $region --profile particle
