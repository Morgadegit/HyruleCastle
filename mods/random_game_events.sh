room_one () {
	echo -e "=========================="
	echo "Surpisingly, not everything is terrible in this terrible, terrible tower. You find yourself in a room filled with adorable kittens ! Some fluffy, some curly, some hairless, but all of them dreadfully cute ! Wilt thou pet the kitties ? Or, showing a surprising amount of prudence, fear a trap and leave quietly ?"
	echo "---------------------------"
	echo "1.Pet 2.Leave"
	read KITTIES
	while [ 1 ]
	do
	if [[ ${KITTIES,,} = pet || KITTIES = 1 ]; then
		echo "Kitty cuteness cannot be denied. You squat down and pet the hoard of cats. A welcome relief from the stress of the tower."
		echo "Will you pet again, or leave ?"
	elif [[ ${KITTIES,,} = leave || KITTIES = 2 ]; then
		echo "Kitties are good and all, but there is a realm that needs saving. You bid farwell to the furry masses and continue on your journey..."
		break
	fi
	done
}

room_two () {
	echo -e "=========================="
	echo "Of course there has to be at least one of those lying around... It's a treasure room ! You can't spend too long in here, but you still managed to swipe some trinkets on the way."
	GAIN=$(( $RANDOM % 3 ))
	echo "You gain $GAIN coins, bringing your haul up to $(( GAIN + $1 )) !"
	return GAIN

}

room_three () {

}

room_four () {

}

room_five () {

}

room_six () {
	while IFS=',' read -r id name requirement rarity; do

	done
} < ../ressources/traps.csv

random_event () {
	TRUE=$(( $RANDOM % 100 - 1 ))
	if (( TRUE <= 35 ))
		ROOM=$(( $RANDOM 1-6 ))
		case ROOM in
			1 )
			room_one
			;;
			2 )
			room_two $1
			return GAIN
			;;
			3 )
			room_three
			;;
			4 )
			room_three
			;;
			5 )
			room_four
			;;
			6 )
			room_five
			;;
		esac
	fi
}
