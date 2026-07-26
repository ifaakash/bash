#!/bin/bash

printf "Choose T/M for balanced workloads, C for CPU-heavy work, R/X for memory-heavy work, I/D/H for storage-heavy work, and P/G/F when you need hardware acceleration\n"

printf "Select the instance class ( only t3 family is supported ):\n"
# T3 family
alist=("t3.nano", "t3.micro", "t3.small", "t3.medium", "t3.large", "t3.xlarge", "t3.2xlarge")
aInstanceClass=$(gum choose alist)

# get instance class
agetInstanceEndpoint="/api/v1/instances/ec2/"

printf "Curling endpoint ${aInstanceClass}/${agetInstanceEndpoint}/global"


# if /api/v1/instances/{service}/{instanceType}/global
