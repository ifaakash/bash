#!/bin/bash
count=10

if [ $count -gt 5 ]; then
	echo "Value is greater than 5, real value is ${count}"
elif [ $count -eq 5 ]; then
	echo "Value is 5"
else
	echo "Just a random text here!"
fi
