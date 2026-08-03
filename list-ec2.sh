#!/bin/bash

printf "–––––––––- LISTING EC2 Instances  –––––––––––\n"
availableRegion=("us-east-1" "us-east-2")
printf "Setup the required environment variables..."
./env.sh
region=$(gum choose ${availableRegion[@]})
printf "Setting $region as default region for all AWS commands for this session\n"

# export "AWS_REGION"=$region
# aws ec2 describe-instances --region ap-south-1

