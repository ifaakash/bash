#!/bin/bash
read -p "Enter your age: " age
read -p "Enter your name: " name

if [ $age -ge 18 ]; then
	printf "Welcome to the party, $name!\n"
else
	echo "Sorry $name, come back in a few years.\n"
fi
