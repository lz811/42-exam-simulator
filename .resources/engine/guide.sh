clear
bash banner.sh
echo "$(tput setaf 6)$(tput bold)Command Reference$(tput sgr0)"
echo =============================
echo "Type $(tput setaf 3)'test'$(tput sgr 0) to test your code."
echo "Type $(tput setaf 3)'exit'$(tput sgr 0) to leave the practice."
echo
echo "$(tput setaf 5)$(tput bold)Cheat commands$(tput sgr0)"
echo "Type $(tput setaf 3)'change'$(tput sgr 0) $(tput setaf 5)[cheat]$(tput sgr 0) to swap the current exercise for another random one from the same level, without affecting your progress."
echo "Type $(tput setaf 3)'skip'$(tput sgr 0) $(tput setaf 5)[cheat]$(tput sgr 0) to auto-pass the current exercise and move on."
echo =============================
read -rp "Press enter to return to the menu: " opt
bash home.sh
