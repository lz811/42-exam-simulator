#!/bin/bash
source fx.sh
source palette.sh

attempt_level() {
    lvl=$1
    step=$2
    total=$3
    clear
    progress_bar "$step" "$total" "RANK02"
    echo "$(tput setaf 2)$(tput bold)Level $lvl is being prepared...$(tput sgr0)"
    spin_wait
    clear
    until bash r02_trial.sh rank02 level$lvl $step $total; do
        if [ $? -eq 255 ]; then
            rm -rf ../../rendu
            rm -f /tmp/.current_subject_rank02_level$lvl;

            exit 0
        fi

        echo "$(tput setaf 1)Test failed. Try again.$(tput sgr0)"
        read -p "Press Enter to retry Level $lvl..."
        clear
    done
    echo "$(tput setaf 2)Level $lvl cleared.$(tput sgr0)"
    sleep 1
}

launch_trial() {
    clear
    bash banner.sh
    echo "$(tput setaf 2)$(tput bold)Live Trial — Rank 02$(tput sgr0)"
    echo "=================================================="
    sleep 1

    step=0
    total=4
    for lvl in 0 1 2 3; do
        step=$((step+1))
        mkdir -p ../../rendu 
        attempt_level $lvl $step $total
    done

    clear
    echo "$(tput setaf 2)$(tput bold)Rank 02 complete.$(tput sgr0)"
    echo "=================================================="
    echo "All levels passed successfully!"
    sleep 3
}

launch_trial
