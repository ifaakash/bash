#!/bin/bash

echo "#-----------------------------------------"
echo "Listing the current running containers"
cid=$(docker ps --format "table {{.ID}}\t{{.Image}}\t{{.Status}}" | grep -i "Plant")
if [ $? -eq 0 ]; then
    echo "Container ${cid} is running fine"
fi
