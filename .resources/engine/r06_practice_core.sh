#!/bin/bash
source palette.sh
source fx.sh

track=$1

root_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

pool=(mini_db mini_serv)

scramble_list() {
    local i tmp size max rand
    size=${#pool[*]}
    max=$(( 32768 / size * size ))

    for ((i = size - 1; i > 0; i--)); do
        while (( (rand = RANDOM) >= max )); do :; done
        rand=$(( rand % (i + 1) ))
        tmp=${pool[i]}
        pool[i]=${pool[rand]}
        pool[rand]=$tmp
    done
    order=("${pool[@]}")
}

scramble_list
total=${#order[@]}
idx=0
mkdir -p "$root_dir/../../rendu"

while true; do
    pick="${order[$idx]}"
    pick_dir="$root_dir/../$track/$pick"
    
    if [ ! -d "$pick_dir" ]; then
        echo -e "${FG_RED}Error: Subject directory not found: $pick_dir${TXT_RESET}"
        exit 1
    fi
    
    cd "$pick_dir" || {
        echo -e "${FG_RED}Error: Cannot change to subject directory${TXT_RESET}"
        exit 1
    }
    
    mkdir -p "$root_dir/../../rendu/$pick"

    if [[ "$pick" == "mini_db" ]]; then
        touch "$root_dir/../../rendu/$pick/mini_db.cpp"
        touch "$root_dir/../../rendu/$pick/mini_db.hpp"
    elif [[ "$pick" == "mini_serv" ]]; then
        touch "$root_dir/../../rendu/$pick/mini_serv.c"
    fi

    if [ ! -f "sub.txt" ]; then
        echo -e "${FG_RED}Error: sub.txt not found in $pick_dir${TXT_RESET}"
        exit 1
    fi
    
    brief=$(cat sub.txt)

    if [ $idx -ge $total ]; then
        clear
        echo "These questions are completed."
        echo "=============================================="
        read -rp "${FG_GREEN}${TXT_BOLD}Please press enter for return to the menu.${TXT_RESET}" enterx
        sleep 2
        cd ../../engine
        bash home.sh
        exit
    fi

    while true; do
        clear
        progress_bar "$((idx+1))" "$total" "RANK06"
        echo -e "${FG_WHITE}$brief${TXT_RESET}"
        echo
        echo "Please type 'test' to test code, 'next' for next or 'exit' for exit."
        echo
        read -rp "/>" input
        case $input in
            next)
                idx=$((idx+1))
                break
                ;;
            test)
                clear
                if [ -f "./tester.sh" ]; then
                    ./tester.sh &
                    worker_pid=$!
                    waited=0

                    while [ $waited -lt 10 ] && kill -0 $worker_pid 2>/dev/null; do
                        sleep 1
                        waited=$((waited+1))
                    done

                    if kill -0 $worker_pid 2>/dev/null; then
                        echo "$(tput setaf 1)$(tput bold)TIMEOUT$(tput sgr 0)"
                        echo "It can be because of infinite loop ∞"
                        echo "Please check your code or just try again."
                        kill $worker_pid 2>/dev/null
                    fi
                else
                    echo "No tester.sh found. Please test manually."
                fi

                echo "=============================================="
                read -rp "${FG_GREEN}${TXT_BOLD}Please press enter to continue your practice.${TXT_RESET}" enter
                break
                ;;
            menu)
                cd ../../../../
                if [ -d rendu ]; then
                    mkdir -p trace
                    cp -r rendu "trace/rendu_backup_$(date +%Y%m%d%H%M%S)"
                    rm -rf rendu
                fi
                cd .resources/engine
                bash home.sh
                exit
                ;;
            exit)
                cd ../../../../
                if [ -d rendu ]; then
                    mkdir -p trace
                    cp -r rendu "trace/rendu_backup_$(date +%Y%m%d%H%M%S)"
                    rm -rf rendu
                fi
                exit 1
                ;;
            *)
                echo "Please type 'test' to test code, 'next' for next or 'exit' to quit."
                ;;
        esac
    done
done
