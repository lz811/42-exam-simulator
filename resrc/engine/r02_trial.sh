#!/bin/bash
source palette.sh
source fx.sh

track=$1
stage=$2
step=${3:-1}
total=${4:-1}

# Directory the script was launched from
root_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# One shared cache file per track/stage so we can resume
pick_cache="/tmp/.current_subject_${track}_${stage}"

topic_pool() {
    case "$stage" in
        level0)
            echo "first_word fizzbuzz ft_putstr ft_strcpy ft_strlen ft_swap repeat_alpha rev_print rot_13 rotone search_and_replace ulstr"
            ;;
        level1)
            echo "alpha_mirror camel_to_snake print_bits do_op ft_atoi ft_strcmp reverse_bits ft_strrev ft_strcspn ft_strdup inter is_power_of_2 last_word max snake_to_camel swap_bits union wdmatch"
            ;;
        level2)
            echo "add_prime_sum epur_str expand_str ft_list_size ft_atoi_base ft_range ft_rrange hidenp lcm paramsum pgcd print_hex rstr_capitalizer str_capitalizer tab_mult"
            ;;
        level3)
            echo "flood_fill fprime ft_itoa ft_split rev_wstr rostring ft_list_foreach sort_int_tab sort_list ft_list_remove_if"
            ;;
        *)
            echo ""
            ;;
    esac
}

select_topic() {
    pool_raw=$(topic_pool)
    IFS=' ' read -r -a pool <<< "$pool_raw"
    pool_size=${#pool[@]}
    rnd_idx=$(( RANDOM % pool_size ))
    pick="${pool[$rnd_idx]}"
    echo "$pick" > "$pick_cache"
}

# Move into the subject folder and stage the empty answer file for it.
stage_topic() {
    mkdir -p "$root_dir/../../rendu/$pick"
    touch "$root_dir/../../rendu/$pick/$pick.c"

    cd "$root_dir/../$track/$stage/$pick" || {
        echo -e "${FG_RED}Subject folder not found.${TXT_RESET}"
        exit 1
    }
}

# Persistent header redrawn every loop turn: progress bar on top, then the brief.
render_header() {
    clear
    progress_header "$step" "$total" "PROGRESS"
    echo -e "${FG_CYAN}${TXT_BOLD}Your subject: $pick${TXT_RESET}"
    echo "=================================================="
    cat sub.txt
    echo
    echo -e "=================================================="
    echo -e "${FG_YELLOW}Type 'test' to check your code · 'skip' (cheat) to auto-pass · 'change' (cheat) to swap the exercise · 'exit' to quit.${TXT_RESET}"
}

if [ -f "$pick_cache" ]; then
    pick=$(cat "$pick_cache")
else
    select_topic
fi

stage_topic

while true; do
    render_header
    read -rp "/>" input
    case $input in
        change)
            select_topic
            pick=$(cat "$pick_cache")
            stage_topic
            ;;
        test)
            clear
            progress_header "$step" "$total" "PROGRESS"
            echo -e "${FG_GREEN}Running tester.sh...${TXT_RESET}"
            ./tester.sh > tester_output.log 2>&1 &
            worker_pid=$!
            waited=0

            while [ $waited -lt 10 ] && kill -0 $worker_pid 2>/dev/null; do
                sleep 1
                waited=$((waited+1))
            done

            if kill -0 $worker_pid 2>/dev/null; then
                echo -e "${FG_RED}${TXT_BOLD}TIMEOUT${TXT_RESET}"
                echo "It can be because of infinite loop ∞"
                echo "Please check your code or just try again."
                kill $worker_pid 2>/dev/null
                echo "=============================================="
                read -rp "${FG_GREEN}${TXT_BOLD}Please press enter to continue your practice.${TXT_RESET}" enter
                continue
            fi

            result=$(cat tester_output.log)
            echo "$result" | tee tester_output.log

            if echo "$result" | grep -q -E "PASSED|SUCCESS"; then
                echo -e "${FG_GREEN}${TXT_BOLD}Passed.${TXT_RESET}"
                rm -f "$pick_cache"
                sleep 1
                exit 0
            else
                echo -e "${FG_RED}${TXT_BOLD}Failed.${TXT_RESET}"
                echo "=============================================="
                read -rp "${FG_GREEN}${TXT_BOLD}Please press enter to continue your practice.${TXT_RESET}" enter
            fi
            ;;
        skip)
            echo -e "${FG_MAGENTA}${TXT_BOLD}[cheat] Skipping this exercise...${TXT_RESET}"
            rm -f "$pick_cache"
            sleep 1
            exit 0
            ;;
        exit)
            echo "Exiting..."
            exit 255
            ;;
        *)
            echo "Please type 'test', 'skip' (cheat), 'change' (cheat), or 'exit'."
            sleep 1
            ;;
    esac
done
