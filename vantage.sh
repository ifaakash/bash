#!/bin/bash
baseEndpoint="https://instances-api.vantage.sh"
printf "Choose T/M for balanced workloads, C for CPU-heavy work, R/X for memory-heavy work, I/D/H for storage-heavy work, and P/G/F when you need hardware acceleration\n"

printf "Select the instance class ( only t3 family is supported ):\n"
# T3 family
list=("t3.nano" "t3.micro" "t3.small" "t3.medium" "t3.large" "t3.xlarge" "t3.2xlarge")
instanceClass=$(gum choose ${list[@]})

# get instance class
getInstanceEndpoint="api/v1/instances/ec2"
targetUrl="${baseEndpoint}/${getInstanceEndpoint}/${instanceClass}/global"
printf "Curling endpoint ${targetUrl}"
curlResult=$(curl -s -f "$targetUrl")

if [ $? -eq 0 ]; then
   printf "Curl passed!\n"
   printf ""
else
   printf "Curl failed!"
fi

# if /api/v1/instances/{service}/{instanceType}/global
