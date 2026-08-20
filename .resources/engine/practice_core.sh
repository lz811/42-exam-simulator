#!/bin/bash
source palette.sh
source fx.sh

track=$1
stage=$2

root_dir="$(cd "$(dirname "$0")" && pwd)"

# Build the topic pool for this track/stage
if [[ "$track" == "rank02" ]]; then
    if [[ "$stage" == *"level0"* ]]; then
        pool=(first_word fizzbuzz ft_putstr ft_strcpy ft_strlen ft_swap repeat_alpha rev_print rot_13 rotone search_and_replace ulstr)
    elif [[ "$stage" == *"level1"* ]]; then
        pool=(alpha_mirror camel_to_snake print_bits do_op ft_atoi ft_strcmp reverse_bits ft_strrev ft_strcspn ft_strdup inter is_power_of_2 last_word max snake_to_camel swap_bits union wdmatch)
    elif [[ "$stage" == *"level2"* ]]; then
        pool=(add_prime_sum epur_str expand_str ft_list_size ft_atoi_base ft_range ft_rrange hidenp lcm paramsum pgcd print_hex rstr_capitalizer str_capitalizer tab_mult)
    elif [[ "$stage" == *"level3"* ]]; then
        pool=(flood_fill fprime ft_itoa ft_split rev_wstr rostring ft_list_foreach sort_int_tab sort_list ft_list_remove_if)
    else
        echo "Invalid level: $stage for rank02"
        exit 1
    fi
elif [[ "$track" == "rank03" ]]; then
    if [[ "$stage" == *"level1"* ]]; then
        pool=(bracket_validator echo_validator mirror_matrix shadow_merge string_sculptor)
    elif [[ "$stage" == *"level2"* ]]; then
        pool=(base_converter cryptic_sorter pattern_tracker permutation_checker twist_sequence whisper_cipher)
    else
        echo "Invalid level: $stage for rank03"
        exit 1
    fi
elif [[ "$track" == "rank04" ]]; then
    if [[ "$stage" == *"level1"* ]]; then
        pool=(ft_popen picoshell sandbox)
    elif [[ "$stage" == *"level2"* ]]; then
        pool=(argo vbc)
    else
        echo "Invalid level: $stage for rank04"
        exit 1
    fi
else
    echo "Invalid rank: $track"
    exit 1
fi

# Fisher-Yates style scramble
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
cd "../$track/$stage/${order[$idx]}"

while true; do
    cd "../${order[$idx]}"
    mkdir -p "$root_dir/../../rendu/${order[$idx]}"

   # Stage the answer file the candidate will write into
if [[ "$track" == "rank03" ]]; then
    touch "$root_dir/../../rendu/${order[$idx]}/${order[$idx]}.py"
elif [[ "$track" == "rank04" && "$stage" == *"level2"* ]]; then
    if [ -f "given.c" ]; then
        cp "given.c" "$root_dir/../../rendu/${order[$idx]}/given.c"
    fi
    touch "$root_dir/../../rendu/${order[$idx]}/${order[$idx]}.c"
    if [[ "${order[$idx]}" == "vbc" ]]; then
        touch "$root_dir/../../rendu/${order[$idx]}/vbc.h"
    fi
else
    touch "$root_dir/../../rendu/${order[$idx]}/${order[$idx]}.c"
fi

    brief=$(cat sub.txt)

    # Whole pool cleared -> back to the dashboard
    if [ $idx -ge $total ]; then
        clear
        echo "These questions at $stage are completed."
        echo "=============================================="
        read -rp "${FG_GREEN}${TXT_BOLD}Please press enter for return to the menu.${TXT_RESET}" enterx
        sleep 2
        cd ../../engine
        bash home.sh
        exit
    fi

    while true; do
        clear
        progress_bar "$((idx+1))" "$total" "${stage^^}"
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
