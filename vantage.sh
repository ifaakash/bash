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
printf "Curling endpoint ${targetUrl}\n"
curlResult=$(curl -s -f "$targetUrl")

if [ $? -eq 0 ]; then
   printf "Curl passed!\n"
   instanceType=$(echo "$curlResult" | jq -r '.instance_type')
   region=$(gum filter $(echo "$curlResult" | jq -r '.pricing | keys[]'))
#   echo $curlResult > curlResult.json
   vCPU=$(echo "$curlResult" | jq -r '.vCPU')
   arch=$(echo "$curlResult" | jq -r '.arch[0]')
   networkPerformance=$(echo $curlResult | jq -r ".network_performance")
   memory=$(echo "$curlResult" | jq -r '.memory')
   enis=$(echo "$curlResult" | jq -r '.vpc.max_enis')
   enis_ip=$(echo "$curlResult" | jq -r '.vpc.ips_per_eni')
   pricing_onDemand=$(echo "$curlResult" | jq -r --arg region "$region" '.pricing[$region].linux.ondemand')

   if [ "$pricing_onDemand" = "null" ] || [ -z "$pricing_onDemand" ]; then
      pricing_onDemand="N/A"
      pricing_monthly="N/A"
   else
      pricing_monthly=$(awk -v od="$pricing_onDemand" 'BEGIN { printf "%.2f", od * 730 }')
   fi

   printf "\n"
   gum table -p --columns "Metric,Specification" <<EOF
Instance Type,$instanceType
Region,$region
vCPUs,$vCPU
Memory,$memory GB
Architecture,$arch
Network Performance,$networkPerformance
Max ENIs,$enis
IPs per ENI,$enis_ip
Hourly Cost (On-Demand),\$$pricing_onDemand
Monthly Cost (Est. * 730h),\$$pricing_monthly
EOF
else
   printf "Curl failed!"
fi

# if /api/v1/instances/{service}/{instanceType}/global
