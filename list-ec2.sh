#!/bin/bash

printf "–––––––––- LISTING EC2 Instances  –––––––––––\n"
availableRegion=("us-east-1" "us-east-2")
printf "Setup the required environment variables..."
source .env.sh
region=$(gum choose ${availableRegion[@]})
printf "Setting $region as default region for all AWS commands for this session\n"

# export "AWS_REGION"=$region
gum spin --spinner dot --title "Fetching instances in $region region" -- sleep 3
selectedInstance=$(aws ec2 describe-instances \
    --query 'Reservations[].Instances[].[InstanceId, Tags[?Key==`Name`]|[0].Value]' \
    --region "$region" --profile particle --output text \
    | gum filter --header "Choose an EC2 instance:" \
    | awk '{print $1}')

# printf "Selected instance: %s\n" "$selectedInstance"
# printf "Starting SSM session to instance $selectedInstance\n"
gum spin --spinner dot --title  "Checking the status of instance with ID $selectedInstance" -- sleep 15 &
SPIN_PID=$!

# echo $SPIN_PID
instanceState=$(aws ec2 describe-instances --instance-ids \
   "$selectedInstance" --query "Reservations[*].Instances[*].State.Name" \
   --output text --profile particle)

kill $SPIN_PID 2>/dev/null
wait $SPIN_PID 2>/dev/null

if [[ "$instanceState" == "stopped" ]]; then
     printf "Instance is in stopped state! Do you want to start the instance?\n"
     choice=$(gum choose "Yes" "No")
     if [[ "$choice" == "Yes" ]]; then
        printf "Starting instance\n"
        aws ec2 start-instances --instance-ids $selectedInstance \
            --region $region --profile particle
     else
        printf "Skipping start action\n"
     fi
fi

# Fetch state of instance
# Provide option to on/off the instance - if on, then off and vice-versa
#aws ssm start-session --target $selectedInstance --region $region --profile particle
