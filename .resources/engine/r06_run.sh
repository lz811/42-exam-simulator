#!/bin/bash
source fx.sh
source palette.sh

root_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Pick one random question for the day
questions=("mini_db" "mini_serv")
rnd_idx=$(( RANDOM % 2 ))
chosen_question="${questions[$rnd_idx]}"

attempt_question() {
    question=$1
    clear
    progress_bar 1 1 "RANK06"
    echo "$(tput setaf 2)$(tput bold)Question: $question is being prepared...$(tput sgr0)"
    spin_wait
    clear
    until bash r06_trial.sh rank06 "" 1 1; do
        if [ $? -eq 255 ]; then
            rm -rf ../../rendu
            rm -f /tmp/.current_subject_rank06_

            exit 0
        fi

        echo "$(tput setaf 1)Test failed. Try again.$(tput sgr0)"
        read -p "Press Enter to retry $question..."
        clear
    done
    echo "$(tput setaf 2)$question cleared.$(tput sgr0)"
    sleep 1
}

launch_trial() {
    clear
    bash banner.sh
    echo "$(tput setaf 2)$(tput bold)Live Trial — Rank 06$(tput sgr0)"
    echo "=================================================="
    echo "$(tput setaf 3)Today's question: $chosen_question$(tput sgr0)"
    echo "=================================================="
    sleep 2

    mkdir -p ../../rendu 
    attempt_question $chosen_question

    echo "=================================================="
    echo "$(tput setaf 2)$(tput bold)Rank 06 trial passed.$(tput sgr0)"
    echo "=================================================="

    if [ -d "../../rendu" ]; then
        stamp=$(date +%Y%m%d_%H%M%S)
        mkdir -p ../../exam
        cp -r ../../rendu "../../exam/rendu_backup_$stamp"
        echo -e "${FG_CYAN}rendu folder backed up to: exam/rendu_backup_$stamp${TXT_RESET}"
        
        rm -rf ../../rendu
        echo -e "${FG_RED}rendu folder cleared after a successful trial.${TXT_RESET}"
    fi

    echo
    read -rp "$(echo -e ${FG_YELLOW}${TXT_BOLD}"Do you want to retry the exam? (y/n): "${TXT_RESET})" again
    case "$again" in
        y|Y)
            echo -e "${FG_YELLOW}Restarting the trial...${TXT_RESET}"
            sleep 1
            bash r06_run.sh
            ;;
        *)
            echo -e "${FG_GREEN}Goodbye!${TXT_RESET}"
            exit 0
            ;;
    esac
}

launch_trial
