#!/bin/bash
source fx.sh
source palette.sh
clear
bash banner.sh
printf "${FG_TEAL}%s${TXT_RESET}\n" "┌─────────────────────────────────────────────────────────┐"
printf "${FG_SLATE}%s${FG_AMBER}%s${FG_SLATE}%s${TXT_RESET}\n" "│" "  Choose your stage — Rank 02  " "│"
printf "${FG_TEAL}%s${TXT_RESET}\n" "└─────────────────────────────────────────────────────────┘"
printf "${FG_TEAL}%s${TXT_RESET}\n" "∼∼∼∼∼∼∼∼∼∼∼∼∼∼∼∼∼∼∼∼∼∼∼∼∼∼∼∼∼∼∼∼∼∼∼∼∼∼∼∼∼∼∼∼∼∼∼∼∼∼∼∼∼∼∼∼∼"
printf "${FG_AMBER}${TXT_BOLD}%s${TXT_RESET}\n" "1 · Level 0 — Foundation"
printf "${FG_AMBER}${TXT_BOLD}%s${TXT_RESET}\n" "2 · Level 1 — Intermediate"
printf "${FG_AMBER}${TXT_BOLD}%s${TXT_RESET}\n" "3 · Level 2 — Advanced"
printf "${FG_AMBER}${TXT_BOLD}%s${TXT_RESET}\n" "4 · Level 3 — Expert"
printf "${FG_TEAL}%s${TXT_RESET}\n" "∼∼∼∼∼∼∼∼∼∼∼∼∼∼∼∼∼∼∼∼∼∼∼∼∼∼∼∼∼∼∼∼∼∼∼∼∼∼∼∼∼∼∼∼∼∼∼∼∼∼∼∼∼∼∼∼∼"
printf "${FG_GREEN}${TXT_BOLD}Enter your choice (1-4): ${TXT_RESET}"
read opt

case $opt in
    menu)
        bash home.sh
        ;;
    1)
        clear
        echo "$(tput setaf 2)$(tput bold)level0 is being prepared $(tput sgr0)"
        spin_wait
        clear
        bash practice_core.sh rank02 level0
        ;;
    2)  
        mkdir ../../rendu
        clear
        echo "$(tput setaf 2)$(tput bold)level1 is being prepared...$(tput sgr0)"
        spin_wait
        clear
        bash practice_core.sh rank02 level1
        ;;
    3) 
        mkdir ../../rendu
        clear
        echo "$(tput setaf 2)$(tput bold)level2 is being prepared...$(tput sgr0)"
        spin_wait
        clear
        bash practice_core.sh rank02 level2
        ;;
    4)
        mkdir ../../rendu
        clear
        echo "$(tput setaf 2)$(tput bold)level3 is being prepared...$(tput sgr0)"
        spin_wait
        clear
        bash practice_core.sh rank02 level3
        ;;
    exit)
        cd ../../../../
        rm -rf rendu
        clear
        exit 1
        ;;
    *)
        echo "$(tput setaf 1)Wrong input$(tput sgr0)"
        sleep 1
        bash r02_picker.sh
esac
