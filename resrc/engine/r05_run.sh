#!/bin/bash
source fx.sh
source palette.sh

attempt_level() {
    lvl=$1
    step=$2
    total=$3
    clear
    progress_bar "$step" "$total" "RANK05"
    echo "$(tput setaf 2)$(tput bold)Round $step of $total is being prepared...$(tput sgr0)"
    spin_wait
    clear
    until bash r05_trial.sh rank05 level$lvl $step $total; do
        if [ $? -eq 255 ]; then
            rm -rf ../../rendu
            rm -f /tmp/.current_subject_rank05_level$lvl;

            exit 0
        fi

        echo "$(tput setaf 1)Test failed. Try again.$(tput sgr0)"
        read -p "Press Enter to retry Round $step..."
        clear
    done
    echo "$(tput setaf 2)Round $step cleared.$(tput sgr0)"
    sleep 1
}

launch_trial() {
    clear
    bash banner.sh
    echo "$(tput setaf 2)$(tput bold)Live Trial — Rank 05$(tput sgr0)"
    echo "=================================================="
    sleep 1

    step=0
    total=3
    for lvl in 1 2 1; do
        step=$((step+1))
        mkdir -p ../../rendu 
        attempt_level $lvl $step $total
    done

    echo "=================================================="
    echo "$(tput setaf 2)$(tput bold)Rank 05 trial passed.$(tput sgr0)"
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
            bash r05_run.sh
            ;;
        *)
            echo -e "${FG_GREEN}Goodbye!${TXT_RESET}"
            exit 0
            ;;
    esac
}

launch_trial
