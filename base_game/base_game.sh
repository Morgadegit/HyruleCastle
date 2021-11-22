#!/bin/bash

# Declaring color variables

RED='\033[0;31m'
NC='\033[0m'
GREEN='\033[0;32m'

# Defining basic combat loop function
 
combat () {
	CHP=$3		# Current HP. Delete this line and use $3 instead of $CHP to keep damage between fights
	EHP=${16} 	# Storing enemy max HP. Might be cool to have healing mobs later ?
	HEAL=$(( $3 / 2))		# Use to check that healing doesn't allow to go over the maximum HP
	if [[ ${27} == 0 ]]; then
		echo "A ferocious ${15} steps up ! To arms !"
	elif [[ ${27} == 1 ]]; then
		echo "${15} is waiting for you, all arrogance and malevolence. Fight for your life."
	fi
	while [ 1 ] 
	do
		echo -e "\n=========================="
		echo "Current HP : ${CHP} / $3"
		echo "${15} HP : ${EHP} / ${16}"
		echo -e "==========================\n"
		while [ 1 ]
		do
		echo -e "Battle requires action ! What shall you do ?"
		echo "-------------------------"
		echo -e "${RED}Attack ${GREEN}Heal${NC}"
		echo "-------------------------"
		read ANSWER
		echo "-------------------------"
		if [[ ${ANSWER,,} = attack ]]; then
			if [[ ${27} == 0 ]]; then
				echo "You bleed the enemy ${15} for ${5} damage, sending it reeling !"
			elif [[ ${27} == 1 ]]; then
				echo "Your strike ${15} for ${5} damage. You fear your strength might be found lacking..."
			fi
			(( EHP -= $5 ))
			break
		elif [[ ${ANSWER,,} = heal ]]; then
			if (( (CHP + HEAL) > $3 )); then
				(( CHP = $3 ))
			else
				(( CHP += HEAL ))
			fi
			echo "Rallying your spirit, you regenerate ${HEAL} HP, getting you to ${CHP} HP."
			break
		else
			echo -e "\nInvalid command. Please choose between the proposed options.\n"
			sleep 1
		fi
		done
		echo "-------------------------"
		sleep 1
		if (( ${EHP} <= 0 )); then
			if [[ ${27} == 0 ]]; then
				echo "The ${15} shall hear the choir of battle nevermore. Your are victorious."
			elif [[ ${27} == 1 ]]; then
				echo "As your enemy's body falls to the ground, dread and adrenaline make way for a bittersweet sense of resolution. How many were sacrificed to free the land of this evil ?"
			fi
			sleep 2
				break
		else
			if [[ ${27} == 0 ]]; then
			echo "Your foe goes on the offensive and lands a mighty blow ! You lose $18 HP !"
			elif [[ ${27} == 1 ]]; then
			echo "${15}'s blow shakes you to your very core. As you take $18 damage, your resolution wavers..."
			fi
		echo "-------------------------"
		(( CHP -= $18 ))
		sleep 1
		fi
		if (( ${CHP} <= 0 )); then
			echo "Sounds grow dim, images grow blurry. You life has come to an end. Rest now, hero."
		return 1
			break
		fi
	done
}

# Storing Character data

while IFS=',' read -r char_id char_name char_hp char_mp char_str char_int char_def char_res char_spd char_luck char_race char_class char_rarity; do
	if [ "$char_id" = '1' ]; then
		break
	fi
done < ../ressources/players.csv

# Storing Enemy data

while IFS=',' read -r mob_id mob_name mob_hp mob_mp mob_str mob_int mob_def mob_res mob_spd mob_luck mob_race mob_class mob_rarity; do
	if [ "$mob_id" = '12' ]; then
		break
	fi
done < ../ressources/enemies.csv

# Executing fight loop for basic enemies

for (( i=1; i < 10 ; i++ ))
do
	echo -e "\n=========================="
	echo -e "Weary and anxious, you step into floor number ${i}"
	echo -e "==========================\n"
	sleep 1
	combat $char_id $char_name $char_hp $char_mp $char_str $char_int $char_def $char_res $char_spd $char_luck $char_race $char_class $char_rarity $mob_id $mob_name $mob_hp $mob_mp $mob_str $mob_int $mob_def $mob_res $mob_spd $mob_luck $mob_race $mob_class $mob_rarity 0
	if [[ "$?" = 1 ]]; then
		echo "Your journey ends here. Better luck next time !"
		exit
	fi

done

# Store Boss data

while IFS=',' read -r mob_id mob_name mob_hp mob_mp mob_str mob_int mob_def mob_res mob_spd mob_luck mob_race mob_class mob_rarity; do
	if [ "$mob_id" = '1' ]; then
		break
	fi
done < ../ressources/bosses.csv

echo -e "==========================\n"
echo -e "Upon reaching the next floor, you feel the air grow heavy as a palpable sense of dread fills your brain. Your next challenge will be the hardest to date...\n"
echo -e "==========================\n"
	sleep 2
	combat $char_id $char_name $char_hp $char_mp $char_str $char_int $char_def $char_res $char_spd $char_luck $char_race $char_class $char_rarity $mob_id $mob_name $mob_hp $mob_mp $mob_str $mob_int $mob_def $mob_res $mob_spd $mob_luck $mob_race $mob_class $mob_rarity 1
	if [[ "$?" = '1' ]]; then
		echo "Your journey ends here. Better luck next time !"
	exit
	else
		echo -e "\nThat being said, you won, well done !"

fi
