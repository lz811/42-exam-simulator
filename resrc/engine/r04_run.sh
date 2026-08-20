#!/bin/bash
source fx.sh
source palette.sh

attempt_level() {
    lvl=$1
    step=$2
    total=$3
    clear
    progress_bar "$step" "$total" "PROGRESS"
    echo "$(tput setaf 2)$(tput bold)Level $lvl is being prepared...$(tput sgr0)"
    spin_wait
    clear
    until bash r04_trial.sh rank04 level$lvl $step $total; do
        if [ $? -eq 255 ]; then
            rm -rf ../../rendu
            rm -f /tmp/.current_subject_rank04_level$lvl;

            exit 0
        fi

        echo "$(tput setaf 1)Test failed. Try again.$(tput sgr0)"
        read -p "Press Enter to retry Level $lvl..."
        clear
    done
    echo "$(tput setaf 2)$(tput bold)Level $lvl cleared.$(tput sgr0)"
    echo "$(tput setaf 3)$(tput bold)🏆 $(epic_praise)$(tput sgr0)"
    sleep 1
}

launch_trial() {
    clear
    bash banner.sh
    echo "$(tput setaf 2)$(tput bold)Live Trial — Rank 04$(tput sgr0)"
    echo "=================================================="
    sleep 1

    step=0
    total=4
    for lvl in 1 2 3 4; do
        step=$((step+1))
        mkdir -p ../../rendu 
        attempt_level $lvl $step $total
    done

    echo "=================================================="
    echo "$(tput setaf 2)$(tput bold)Rank 04 trial passed.$(tput sgr0)"
    echo "$(tput setaf 3)$(tput bold)👑 $(epic_praise)$(tput sgr0)"
    echo "$(tput setaf 3)You are, without a doubt, a truly great programmer.$(tput sgr0)"
    echo "=================================================="

    # Snapshot rendu into exam/ before wiping it
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
            bash r04_run.sh
            ;;
        *)
            echo -e "${FG_GREEN}Goodbye!${TXT_RESET}"
            exit 0
            ;;
    esac
}

launch_trial
