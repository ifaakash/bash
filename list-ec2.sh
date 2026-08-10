#!/bin/bash

printf "–––––––––- LISTING EC2 Instances  –––––––––––\n"
availableRegion=("us-east-1" "us-east-2")
printf "Setup the required environment variables..."
source .env.sh

printf "is this running?"
gum spin --spinner dot --title "Validating if AWS_REGION is setup in the shell" \
  -- bash -c '
  if [[-n "AWS_REGION:-" ]]; then
      echo "set"
  else
      echo "unset"
  fi
  '
# Validate all env variables are configured or not!
# if not; exit the script
region=$(gum choose ${availableRegion[@]})
printf "Setting $region as default region for all AWS commands for this session\n"

# export "AWS_REGION"=$region
gum spin --spinner dot --title "Fetching instances in $region region" -- sleep 3
selectedInstance=$(aws ec2 describe-instances \
    --query 'Reservations[].Instances[].[InstanceId, Tags[?Key==`Name`]|[0].Value]' \
    --region "$region" --profile $profile --output text \
    | gum filter --header "Choose an EC2 instance:" \
    | awk '{print $1}')

# printf "Selected instance: %s\n" "$selectedInstance"
# printf "Starting SSM session to instance $selectedInstance\n"
#gum spin --spinner dot --title  "Checking the status of instance with ID $selectedInstance" -- sleep 15 &
#SPIN_PID=$!

# echo $SPIN_PID

instanceState=$(gum spin --spinner dot --title "Checking the status of instance with ID $selectedInstance" \
    -- aws ec2 describe-instances --instance-ids \
   "$selectedInstance" --query "Reservations[*].Instances[*].State.Name" \
   --output text --profile $profile )

#kill $SPIN_PID 2>/dev/null
#wait $SPIN_PID 2>/dev/null

if [[ "$instanceState" == "stopped" ]]; then
     printf "Instance is in STOPPED state! Do you want to start the instance?\n"
     choice=$(gum choose "Yes" "No")
     if [[ "$choice" == "Yes" ]]; then
        printf "STARTING instance\n"
        aws ec2 start-instances --instance-ids $selectedInstance \
            --region $region --profile $profile
        printf "Instance is RUNNING now!\n"
     else
        printf "Skipping start action\n"
     fi
fi


printf "STARTING SSM SESSION TO THE INSTANCE\n"
# The start session should only be allowed if the instance is running
aws ssm start-session --target $selectedInstance --profile $profile \
    --region $region
