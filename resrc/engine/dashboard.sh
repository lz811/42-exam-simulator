source palette.sh
mkdir -p ../../rendu
clear
bash banner.sh
printf "${FG_TEAL}%s${TXT_RESET}\n" "╔═══════════════════════════════════════════════════════════╗"
printf "${FG_SLATE}%s${FG_AMBER}%s${FG_SLATE}%s${TXT_RESET}\n" "║" "               ⟡  E X A M   C O N S O L E  ⟡               " "║"
printf "${FG_TEAL}%s${TXT_RESET}\n" "╟───────────────────────────────────────────────────────────╢"
printf "${FG_SLATE}${TXT_DIM}%s${TXT_RESET}\n" "  ‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾"
printf "${FG_AMBER}${TXT_BOLD}%s${TXT_RESET}\n" "  ▸ 1   Command Reference"
printf "${FG_AMBER}${TXT_BOLD}%s${TXT_RESET}\n" "  ▸ 2   Rank 02"
printf "${FG_AMBER}${TXT_BOLD}%s${FG_TEAL}%s${TXT_RESET}\n" "  ▸ 3   Rank 03 " " ‹New CC›"
printf "${FG_AMBER}${TXT_BOLD}%s${FG_TEAL}%s${TXT_RESET}\n" "  ▸ 4   Rank 04 " " ‹New CC›"
printf "${FG_AMBER}${TXT_BOLD}%s${FG_TEAL}%s${TXT_RESET}\n" "  ▸ 5   Rank 05 " " ‹New CC›"
printf "${FG_AMBER}${TXT_BOLD}%s${TXT_RESET}\n" "  ▸ 6   Rank 06"
printf "${FG_SLATE}${TXT_DIM}%s${TXT_RESET}\n" "  ‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾"
printf "${FG_TEAL}%s${TXT_RESET}\n" "╚═══════════════════════════════════════════════════════════╝"
printf "${FG_GREEN}${TXT_BOLD}➤ Enter your choice (1-6): ${TXT_RESET}"
read opt
case $opt in
    1)
        bash guide.sh
        ;;
    2)
        bash r02_gate.sh
        ;;
    3)
        bash r03_gate.sh
        ;;
    4)
        bash r04_gate.sh
        ;;
    5)
        bash r05_gate.sh
        ;;
    6)
        bash r06_gate.sh
        ;;
    
    exit)
        cd ../..
        rm -rf rendu
        clear
        exit 1
        ;;
    
    *)
        echo "Invalid choice. Please enter a number from 1 to 6."
        sleep 1
        clear
        bash home.sh
esac
