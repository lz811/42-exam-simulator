#!/bin/bash
source fx.sh
source palette.sh
clear
bash banner.sh
printf "${FG_TEAL}%s${TXT_RESET}\n" "┌─────────────────────────────────────────────────────────┐"
printf "${FG_SLATE}%s${FG_AMBER}%s${FG_SLATE}%s${TXT_RESET}\n" "│" "  Choose your stage — Rank 04  " "│"
printf "${FG_TEAL}%s${TXT_RESET}\n" "└─────────────────────────────────────────────────────────┘"
printf "${FG_TEAL}%s${TXT_RESET}\n" "∼∼∼∼∼∼∼∼∼∼∼∼∼∼∼∼∼∼∼∼∼∼∼∼∼∼∼∼∼∼∼∼∼∼∼∼∼∼∼∼∼∼∼∼∼∼∼∼∼∼∼∼∼∼∼∼∼"
printf "${FG_AMBER}${TXT_BOLD}%s${TXT_RESET}\n" "1 · Level 1 — Intermediate"
printf "${FG_AMBER}${TXT_BOLD}%s${TXT_RESET}\n" "2 · Level 2 — Advanced"
printf "${FG_AMBER}${TXT_BOLD}%s${TXT_RESET}\n" "3 · Back to Rank Menu"
printf "${FG_TEAL}%s${TXT_RESET}\n" "∼∼∼∼∼∼∼∼∼∼∼∼∼∼∼∼∼∼∼∼∼∼∼∼∼∼∼∼∼∼∼∼∼∼∼∼∼∼∼∼∼∼∼∼∼∼∼∼∼∼∼∼∼∼∼∼∼"
printf "${FG_GREEN}${TXT_BOLD}Enter your choice (1-3): ${TXT_RESET}"
read opt

case $opt in
    menu)
        bash home.sh
        ;;
    1)
        clear
        echo "$(tput setaf 2)$(tput bold)level1 is being prepared...$(tput sgr0)"
        spin_wait
        clear
        bash practice_core.sh rank04 level1
        ;;
    2) 
        mkdir ../../rendu
        clear
        echo "$(tput setaf 2)$(tput bold)level2 is being prepared...$(tput sgr0)"
        spin_wait
        clear
        bash practice_core.sh rank04 level2
        ;;
    exit)
        cd ../../../../
        rm -rf rendu
        clear
        exit
        ;;
    3)
        bash r04_gate.sh
        ;;
    *)
        echo "$(tput setaf 1)Wrong input$(tput sgr0)"
        sleep 1
        bash r04_run.sh
esac
