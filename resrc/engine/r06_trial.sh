#!/bin/bash
source palette.sh
source fx.sh

track=$1
stage=$2
step=${3:-1}
total=${4:-1}

root_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

pick_cache="/tmp/.current_subject_${track}_${stage}"

topic_pool() {
    echo "mini_db mini_serv"
}

select_topic() {
    pool_raw=$(topic_pool)
    IFS=' ' read -r -a pool <<< "$pool_raw"
    pool_size=${#pool[@]}
    rnd_idx=$(( RANDOM % pool_size ))
    pick="${pool[$rnd_idx]}"
    echo "$pick" > "$pick_cache"
}

stage_topic() {
    mkdir -p "$root_dir/../../rendu/$pick"

    if [[ "$pick" == "mini_db" ]]; then
        [ ! -f "$root_dir/../../rendu/$pick/mini_db.cpp" ] && touch "$root_dir/../../rendu/$pick/mini_db.cpp"
        [ ! -f "$root_dir/../../rendu/$pick/mini_db.hpp" ] && touch "$root_dir/../../rendu/$pick/mini_db.hpp"
    elif [[ "$pick" == "mini_serv" ]]; then
        [ ! -f "$root_dir/../../rendu/$pick/mini_serv.c" ] && touch "$root_dir/../../rendu/$pick/mini_serv.c"
    fi

    cd "$root_dir/../$track/$pick" || {
        echo -e "${FG_RED}Subject folder not found.${TXT_RESET}"
        exit 1
    }
}

render_header() {
    clear
    progress_header "$step" "$total" "RANK06"
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
    read -rp "/> " input
    case "$input" in
        test)
            clear
            progress_header "$step" "$total" "RANK06"
            echo -e "${FG_GREEN}Running tester.sh...${TXT_RESET}"
            if [ -f "./tester.sh" ]; then
                ./tester.sh > tester_output.log 2>&1 &
                worker_pid=$!
                waited=0
                while [ $waited -lt 30 ] && kill -0 $worker_pid 2>/dev/null; do
                    sleep 1
                    waited=$((waited+1))
                done

                if kill -0 $worker_pid 2>/dev/null; then
                    echo -e "${FG_RED}${TXT_BOLD}TIMEOUT${TXT_RESET}"
                    echo "It can be because of infinite loop "
                    echo "Please check your code or just try again."
                    pkill -P $worker_pid 2>/dev/null
                    kill -9 $worker_pid 2>/dev/null
                    sleep 1
                    exit 1
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
                    sleep 1
                    exit 1
                fi
            else
                echo -e "${FG_YELLOW}No tester available for this subject. Please test manually.${TXT_RESET}"
                sleep 1
            fi
            ;;
        skip)
            echo -e "${FG_MAGENTA}${TXT_BOLD}[cheat] Skipping this exercise...${TXT_RESET}"
            rm -f "$pick_cache"
            sleep 1
            exit 0
            ;;
        change)
            select_topic
            pick=$(cat "$pick_cache")
            stage_topic
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
