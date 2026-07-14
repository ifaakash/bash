cat <<EOF
1. Order Coffee
2. Order Tea
3. Exit
EOF

while (true);
do
	read -p "What would you like? " choice
	if ((choice==1)); then
		printf "Coffee coming right up!\n"
	elif ((choice==2)); then
		printf "Tea is on the way!\n"
	elif ((choice ==3)); then
		printf "Goodbye!\n"
		break
	else
		printf "Unknown order.\n"
	fi
done
