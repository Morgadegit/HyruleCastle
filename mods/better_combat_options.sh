#!/bin/bash

LRED='\033[1;31m'

protect() {
	if [[ ${3} = 0 ]]; then
		echo "Your foe goes on the offensive, but you were protected ! You lose "$((${2}/2))" HP !"
	elif [[ ${3} = 1 ]]; then
		echo -e "Though ${LRED}${1}'s${NC} blows be mighty, you are no less stalwart. You take "$((${2}/2))" damage..."
	fi
}

flee() {
	if [[ ${2} = 0 ]]; then
		echo "Cowardice takes hold and you run away screaming like a child."
	elif [[ ${2} = 1 ]]; then
		echo "Faced with certain death, your resolve falters. Your weapons drop from your hands and you flee most unceremoniously."
	fi
	echo "As you exit the tower, out of breath and full of shame, you can feel the universe booing your cowardice. Will you ever live out this humiliation ?"
	exit
}
