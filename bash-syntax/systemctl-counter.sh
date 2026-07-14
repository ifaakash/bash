#!/bin/bash

exit_function() {
	exit 1
}

for ((i=0; i<=10; i++))
do
    if [ $i -ge 5 ]; then
        exit_function
        echo "Returning exit status code as ${$?}"
    fi
    echo "Hello"
    sleep 1
done

