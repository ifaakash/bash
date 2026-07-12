#!/bin/bash

printf "Listing all ASG within the current AWS account and region"
aws autoscaling describe-auto-scaling-groups \
  --query 'AutoScalingGroups[].AutoScalingGroupName' \
  --output table

printf "Want to update the ASG desired count?"
while true; do
    read -p "Enter Y to continue: " choice
    if [ "$choice" == 'Y' ]; then
		printf 'Enter AWS Region\n'
		read region

		printf 'Desired capacity\n'
		read desired_count

		printf 'Enter ASG name\n'
		read asg_name

		printf "–––––––––– Updating ASG desired capacity –––––––––––\n"
		aws autoscaling update-auto-scaling-group \
		  --auto-scaling-group-name $asg_name \
		  --desired-capacity $desired_count
     fi
     else
       break
     fi
done


# aws autoscaling update-auto-scaling-group \
#   --auto-scaling-group-name my-asg \
#   --min-size 2 \
#   --max-size 5 \
#   --desired-capacity 3
