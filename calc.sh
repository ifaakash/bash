while (true);
do
cat<<EOF
Example of entering the input
./calc.sh add 10 5
EOF
	if (($# != 3)); then
		printf "Please provide proper number of arguments\n"
		break
	else
		script_name=$0
		option=$1
		args1=$2
		args2=$3
		printf "Script name is $script_name\n"
		if [[ "$option" == "add" ]]; then
			printf "$args1 + $args2 = %d\n" "$((args1 + args2))"
		elif [[ $option == "sub" ]]; then
			printf "$args1 - $args2 = %d\n" "$((arsg1 - args2))"
		else
			printf "$args1 * $args2 = %d\n" "$((args1 * args2))"
		fi
		break
	fi
done
