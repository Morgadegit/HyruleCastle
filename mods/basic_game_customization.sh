#!/bin/bash


difficulty () {

# ===== titre =======
echo -e "\n                  ===== The Hyrule Castle ====\n"
echo "1.New Game ---- 2.Quit"
echo "---------------------------------------"

# ===== choisir entre newGame et quit =====
read MENU
	while [ 1 ]
	do
		if [[ ${MENU,,} = "new game" || ${MENU} = '1' ]]; then
		while [ 1 ]
		do
			echo -e "\n==== Please choose difficulty level ===\n"
			echo "1.Normal 2.Difficult 3.Insane"
			echo "---------------------------------------"
			sleep 1
			# ==== pour choisir la dificulté ====
			read DIFFICULTY
			# ==== Normal ====
			if [[ ${DIFFICULTY,,} = normal || ${DIFFICULTY} = '1' ]]; then 
				echo "You have chosen a normal difficulty."
				DIFFMOD=1
				break
			elif [[ ${DIFFICULTY,,} = difficult || ${DIFFICULTY} = '2' ]]; then 
				echo "You have chosen to embark on a difficulty journey..."
				DIFFMOD=$(( 3 / 2 | bc ))
				break
			elif [[ ${DIFFICULTY,,} = insane  || ${DIFFICULTY} = '3' ]]; then 
				echo "Insanity awaits !"
				DIFFMOD=2
				break
			else
				echo "Incorrect entry, please choose between the proposed options."
			fi
		done
		elif [[ ${MENU,,} = "quit" || ${MENU} = '2' ]]; then 
			echo "That's a scary tower innit ? See you around !"
			exit
		else 
			echo "Incorrect entry, please choose between the proposed options."
		fi
		break
	done
}

height () {
	while [ 1 ]
	do
		echo -e "\n==== How many floors will this tower contain ? ===\n"
		echo "10 20 50 100"
		echo "---------------------------------------"
		sleep 1
		read HEIGHT
		if [[ ${HEIGHT} = '10' || ${HEIGHT} = '20' || ${HEIGHT} = '50' || ${HEIGHT} = '100' ]]; then
			echo "You have decided to attack a tower ${HEIGHT} floors tall. Ready for the climb ?"
			break
		else
			echo -e "Incorrect entry, please choose between the proposed options.\n"
		fi
	done
}
