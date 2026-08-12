#!/bin/bash

# List and connect to EC2 instances interactively via SSM.
# Requires: gum (charmbracelet/gum), aws-cli, session-manager-plugin.
# Sources .env.sh for AWS_PROFILE and other env variables.

# Exit immediately on any command failure or Ctrl+C.
set -e
trap 'exit 130' INT

availableRegion=("us-east-1" "us-east-2")

printf "–––––––––- LISTING EC2 Instances  –––––––––––\n"

# ------------------------------------------------------------------
# 1. Source environment variables (AWS_PROFILE, etc.)
# ------------------------------------------------------------------
printf "–––––––––- Setup the required environment variables –––––––––-\n"
source .env.sh

# ------------------------------------------------------------------
# 2. Validate that required env variables are set before proceeding.
#    Gum spin hides output by default, so --show-output is needed.
# ------------------------------------------------------------------
gum spin --spinner dot --title "Validating if required env variables are set" \
  --show-output \
  -- bash -c '
  if [[ -n "${AWS_PROFILE:-}" ]]; then
      printf "AWS_PROFILE is set\n"
  else
      printf "AWS_PROFILE is not set yet! Exiting...\n"
      exit 1
  fi
  '

# ------------------------------------------------------------------
# 3. Prompt user to select an AWS region interactively via gum choose.
# ------------------------------------------------------------------
region=$(gum choose "${availableRegion[@]}")
printf "–––––––––- Setting %s as default region –––––––––-\n" "$region"

# ------------------------------------------------------------------
# 4. Fetch all EC2 instances in the selected region and let the user
#    pick one using gum filter. The JMESPath query returns InstanceId
#    and the Name tag for each instance. awk extracts just the ID.
# ------------------------------------------------------------------
gum spin --spinner dot --title "Fetching instances in $region region" -- sleep 3
selectedInstance=$(aws ec2 describe-instances \
    --query 'Reservations[].Instances[].[InstanceId, Tags[?Key==`Name`]|[0].Value]' \
    --region "$region" --profile "$profile" --output text \
    | gum filter --header "Choose an EC2 instance:" \
    | awk '{print $1}')

# ------------------------------------------------------------------
# 5. Poll the current state of the selected instance.
#    Possible states: pending | running | stopping | stopped | terminated
# ------------------------------------------------------------------
instanceState=$(gum spin --spinner dot --title "Checking the status of instance with ID $selectedInstance" \
    -- aws ec2 describe-instances --instance-ids \
   "$selectedInstance" --query "Reservations[*].Instances[*].State.Name" \
   --output text --profile "$profile" --region "$region")

# ------------------------------------------------------------------
# 6. If the instance is stopped, offer to start it.
#    aws ec2 wait instance-running blocks until the instance is
#    fully running (timeout: 10 min).
# ------------------------------------------------------------------
if [[ "$instanceState" == "stopped" ]]; then
     printf "Instance is in STOPPED state! Do you want to start the instance?\n"
     choice=$(gum choose "Yes" "No")
     if [[ "$choice" == "Yes" ]]; then
        printf "STARTING instance\n"
        aws ec2 start-instances --instance-ids "$selectedInstance" \
            --region "$region" --profile "$profile"
        gum spin --spinner dot --title "Waiting for instance to come up healthy!" \
            -- aws ec2 wait instance-running --instance-ids "$selectedInstance" \
            --profile "$profile" --region "$region"
        instanceState="running"
        printf "Instance is RUNNING now!\n"
     else
        printf "Skipping start action\n"
     fi
fi

# ------------------------------------------------------------------
# 7. Verify that the Session Manager plugin is installed locally.
#    Output and errors are redirected to /dev/null.
# ------------------------------------------------------------------
printf "Checking if session manager plugin is installed or not?\n"
if session-manager-plugin &> /dev/null; then
   printf "Session manager plugin is installed!\n"
else
   printf "Session manager plugin is not installed!\n"
fi

# ------------------------------------------------------------------
# 8. Start an SSM session only if the instance is in running state.
# ------------------------------------------------------------------
if [[ "$instanceState" == "running" ]]; then
    printf "STARTING SSM SESSION TO THE INSTANCE\n"
    aws ssm start-session --target "$selectedInstance" --profile "$profile" \
        --region "$region"
else
    printf "Instance is in %s state. Cannot start SSM session (requires running state).\n" "$instanceState"
fi

# ------------------------------------------------------------------
# 9. Prompt user whether to stop the instance after use.
# ------------------------------------------------------------------
printf "Do you want to stop the instance?\n"
choice=$(gum choose "Yes" "No")
if [[ "$choice" == "Yes" ]]; then
    printf "Stopping the instance %s...\n" "$selectedInstance"
    aws ec2 stop-instances --instance-ids "$selectedInstance" \
        --profile "$profile" --region "$region"
    printf "Instance stop initiated.\n"
fi

