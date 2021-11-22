#!/bin/bash

# =============== Declaring color variables ===================

RED='\033[0;31m'
NC='\033[0m'
GREEN='\033[0;32m'
CYAN='\033[0;36m'
LRED='\033[1;31m'
PRPL='\033[1;35m'
BRWN='\033[0;33m'
PINK='\033[1;35m'

# ================ Handling mods ================

BCO=0
BGC=0
RGE=0

while [ "$1" != "" ]; do
		case $1 in
				better_combat_options.sh )
						source ../mods/better_combat_options.sh
						(( BCO = 1 ))
						shift
						;;
				basic_game_customization.sh )
						source ../mods/basic_game_customization.sh 
						(( BGC = 1 ))
						shift
						;;
		esac
		shift
done

# ================== Fight Options =================

attack () {
		if [[ $2 == 0 ]]; then
				echo -e "You bleed the enemy ${LRED}$3${NC} for $4 damage, sending it reeling !"
		elif [[ $2 == 1 ]]; then
				echo -e "You strike ${LRED}$3${NC} for $4 damage. You fear your strength might be found lacking..."
		fi
		(( $1 -= $4 ))
}

# ================ Combat loop ===================

combat () {
		CHP=${28}		# Allows for reporting damage from a fight to the next
		EHP=${16}		# Enemy current HP 
		HEAL=$(( $3 / 2 ))		

		if [[ ${27} == 0 ]]; then
				echo -e "A ferocious ${LRED}${15}${NC} steps up ! To arms !"
		elif [[ ${27} == 1 ]]; then
				echo -e "${PRPL}${15}${NC} is waiting for you, all arrogance and malevolence. Fight for your life."
		fi

# =========================== Player Turn ========================

while [ 1 ] 
do	
		echo -e "\n=========================="
		echo -e "${CYAN}${2}'s${NC} Current HP : ${CHP} / $3"
		echo -e "${LRED}${15}${NC} HP : ${EHP} / ${16}"
		echo -e "==========================\n"

		while [ 1 ]
		do
				echo -e "Battle requires action ! What shall you do ?"
				echo "-------------------------"
				echo -e "${RED}1.Attack ${GREEN}2.Heal${NC}"
				if [[ $BCO == 1 ]]; then
						echo -e "${BRWN}3.Protect ${PINK}4.Escape${NC}"
				fi
				echo "-------------------------"
				read ANSWER
				echo "-------------------------"

				if [[ ${ANSWER,,} = attack || ${ANSWER} = "1" ]]; then
						attack EHP "${27}" "${15}" "${5}"
						break
				elif [[ ${ANSWER,,} = heal || ${ANSWER} = "2" ]]; then
						if (( (CHP + HEAL) <= $3  )); then (( CHP += HEAL )); else (( CHP = $3 )); fi
						echo "Rallying your spirit, you regenerate ${HEAL} HP, getting you to ${CHP} HP."
						break
				elif [[ $BCO == 1 && ( ${ANSWER,,} = protect || ${ANSWER} = "3" ) ]]; then
						echo "You steel yourself against your opponent's next assault..."
						break
				elif [[ $BCO == 1 && ( ${ANSWER,,} = escape || ${ANSWER} = "4" ) ]]; then
						flee "${15}" "${27}"
						return -2
						break
				else
						echo -e "\nInvalid command. Please choose between the proposed options.\n"
				fi
		done

		echo "-------------------------"

# ======================== Checking Enemy Death ====================

if (( ${EHP} <= 0 )); then
		if [[ ${27} == 0 ]]; then
				echo -e "The ${LRED}${15}${NC} shall hear the choir of battle nevermore. Your are victorious."
		elif [[ ${27} == 1 ]]; then
				echo "As your enemy's body falls to the ground, dread and adrenaline make way for a bittersweet sense of resolution. How many were sacrificed to free the land of this evil ?"
				echo "Whatever the cost may have bee,, a new day rises nevertheless on a free realm. Congratulations, hero !"
		fi
		return "$CHP"
		fi

# =========================== Enemy Turn ==========================

if [[ $BCO == 1 && ( ${ANSWER,,} = protect || ${ANSWER} = "3" ) ]]; then
		protect ${15} ${18} ${27}
		(( CHP -= ( ${18} / 2 ) ))
elif [[ ${27} == 0 ]]; then
		echo "Your foe goes on the offensive and lands a mighty blow ! You lose ${18} HP !"
		(( CHP -= ${18} ))
elif [[ ${27} == 1 ]]; then
		echo "${15}'s blow shakes you to your very core. As you take ${18} damage, your resolution wavers..."
		(( CHP -= ${18} ))
fi

echo "-------------------------"

# ========================= Player Death Check ====================

if (( CHP <= 0 )); then
		echo "Sounds grow dim, images grow blurry. You life has come to an end. Rest now, hero."
		echo "Your journey ends here. As the crows gather around you, you ponder on your biggest regret..."
		exit
fi
done
}

# == Function to get the rarity of an element based on rarity vector. Probably not the best way to do this. ==

get_rarity () {
		CHOICE=$(( $RANDOM % 100 + 1 ))
		if (( CHOICE >= 1 && CHOICE <= 50 )); then
				RESULT=1
		elif (( CHOICE >= 51 && CHOICE <= 80 )); then
				RESULT=2
		elif (( CHOICE >= 81 && CHOICE <= 95 )); then
				RESULT=3
		elif (( CHOICE >= 96 && CHOICE <= 99 )); then
				RESULT=4
		elif (( CHOICE == 100 )); then
				RESULT=5
		fi
		return $RESULT
}

# This takes the rarity value, looks at how many elements have that rarity and stores it to get an index later.

get_index () {
		INDEX=0

		while IFS=',' read -r id name hp mp str int def res spd luck race class rarity; do
				if [[ "${rarity::-1}" = $1 ]]; then
						(( INDEX++ ))
				fi
		done < "${2}"
		if (( INDEX == 0 )); then (( INDEX = 1 )); fi
		return $INDEX
}

# ============ Getting difficulty and game length ================

if [[ $BGC = '1' ]]; then
		difficulty
		height
else
		HEIGHT=10
		DIFFMOD=1
fi

# =================== Storing Character data =====================

get_rarity
CHAR_RARE=$?
get_index $CHAR_RARE "../ressources/players.csv" 
PICK=$(( 1 + $RANDOM % $? ))

while IFS=',' read -r char_id char_name char_hp char_mp char_str char_int char_def char_res char_spd char_luck char_race char_class char_rarity; do
		if [[ "${char_rarity::-1}" = $CHAR_RARE ]]; then
				(( PICK-- ))
				if (( PICK == 0 ));then
						break
				fi
				fi
		done < ../ressources/players.csv

		current_hp=$char_hp
		COIN=12

# ====================== Tower climbing ==========================

BOSS=0

echo -e "\nYou are ${CYAN}${char_name}${NC}, and the tower stands ominious before you..."

for (( i=1; i <= HEIGHT ; i++ ))
do
		if (( i % 10 == 0 )); then BOSS='1'; else BOSS='0'; fi	# Are we on a Boss floor ?

		if [[ ($RGE = 1 && $i > 1) || $BOSS = '1' ]]; then
				random_event COIN
				let COIN+=$?
		fi

# ================== Get next mob's stats ======================

if (( BOSS == 0 )); then CSV_PATH="../ressources/enemies.csv"; elif (( BOSS == 1 )); then CSV_PATH="../ressources/bosses.csv"; fi

# ======== Get mob index on the basis of their rarity =======

get_rarity
MOB_RARE=$?
get_index $MOB_RARE $CSV_PATH 
PICK=$(( 1 + $RANDOM % $? ))

while IFS=',' read -r mob_id mob_name mob_hp mob_mp mob_str mob_int mob_def mob_res mob_spd mob_luck mob_race mob_class mob_rarity; do
		if [[ "${mob_rarity::-1}" = $MOB_RARE ]]; then
				(( PICK-- ))
				if (( PICK == 0 ));then
						break
				fi
				fi
		done < "${CSV_PATH}"

# ================= Now the displays begin ==================

if [[ $BOSS = 0 ]]; then
		echo -e "\n=========================="
		echo -e "Weary and anxious, you step into the main chamber of floor number ${i}..."
		echo -e "==========================\n"
else
		echo -e "==========================\n"
		echo -e "Upon reaching the next floor, you feel the air grow heavy as a palpable sense of dread fills your brain. Your next challenge will be the hardest to date...\n"
		echo -e "==========================\n"
fi

combat "$char_id" "$char_name" "$char_hp" "$char_mp" "$char_str" "$char_int" "$char_def" "$char_res" "$char_spd" "$char_luck" "$char_race" "$char_class" "$char_rarity" "$mob_id" "$mob_name" "$(( DIFFMOD * "$mob_hp" ))" "$(( DIFFMOD * "$mob_mp" ))" "$(( DIFFMOD * "$mob_str" ))" "$(( DIFFMOD * "$mob_int" ))" "$(( DIFFMOD * "$mob_def" ))" "$(( DIFFMOD * "$mob_res" ))" "$(( DIFFMOD * "$mob_spd" ))" "$(( DIFFMOD * "$mob_luck" ))" "$mob_race" "$mob_class" "$mob_rarity" "$BOSS" $current_hp

if (( i == HEIGHT )); then
		echo "The tower conquered, the day is yours and the realm finally freed from evil. Well done, hero."
		exit
else

		(( current_hp = $? ))
		if [[ BGC = 1 ]]; then
				(( COIN++ ))
				echo "You have found a coin ! you know own $COIN coins !"
		fi
		fi
done
