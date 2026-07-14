#!/bin/bash
start=1
end=10

for ((i=$start;i<=$end;i++))
do
	if (($i == 0)); then
		printf "Bro, Number is $i"
	elif (("$i" % 2 == 0)); then
		printf "$i is even\n"
	else
		printf "$i is odd\n"
	fi
done
