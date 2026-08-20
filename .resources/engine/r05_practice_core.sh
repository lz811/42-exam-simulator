#!/bin/bash
source palette.sh

track=$1
stage=$2

root_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
pick_cache="/tmp/.current_subject_${track}_${stage}"

topic_pool() {
    case "$stage" in
        level1)
            echo "spiral_matrix string_compressor meeting_scheduler"
            ;;
        level2)
            echo "graph_cycle_detector prism_detector word_ladder"
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

stage_files() {
    mkdir -p "$root_dir/../../rendu/$pick"

    [ ! -f "$root_dir/../../rendu/$pick/$pick.py" ] && touch "$root_dir/../../rendu/$pick/$pick.py"
}

enter_topic_dir() {
    cd "$root_dir/../rank05/$stage/$pick" || {
        echo -e "${FG_RED}Subject folder not found.${TXT_RESET}"
        exit 1
    }
}

if [ -f "$pick_cache" ]; then
    pick=$(cat "$pick_cache")
    echo -e "${FG_BLUE}Resuming previous subject: $pick${TXT_RESET}"
else
    select_topic
fi

stage_files
enter_topic_dir

clear
echo -e "${FG_CYAN}${TXT_BOLD}Your subject: $pick${TXT_RESET}"
echo "=================================================="
cat sub.txt
echo
echo -e "=================================================="
echo -e "${FG_YELLOW}Type 'test' to test your code, 'next' to get a new question, or 'exit' to quit.${TXT_RESET}"

while true; do
    read -rp "/> " input
    case "$input" in
        test)
            clear
            echo -e "${FG_GREEN}Running tester.sh...${TXT_RESET}"
			result=$(yes '' | ./tester.sh 2>&1 | tee tester_output.log)
            echo "$result" | tee tester_output.log

            if echo "$result" | grep -q "ALL TESTS PASSED!"; then
                echo -e "${FG_GREEN}${TXT_BOLD}Passed.${TXT_RESET}"
                rm -f "$pick_cache"
                sleep 1
          
            else
                echo -e "${FG_RED}${TXT_BOLD}Failed.${TXT_RESET}"
                sleep 1
          
            fi

			echo
            echo "Please type 'test' to test code, 'next' for next or 'exit' for exit."
            ;;
        next)
            echo -e "${FG_BLUE}Picking a new subject...${TXT_RESET}"
            select_topic
            stage_files
            enter_topic_dir
            clear
            echo -e "${FG_CYAN}${TXT_BOLD}Your subject: $pick${TXT_RESET}"
            echo "=================================================="
            cat sub.txt
            echo
            echo -e "=================================================="
            echo -e "${FG_YELLOW}Type 'test' to test your code, 'next' to get a new question, or 'exit' to quit.${TXT_RESET}"
            ;;
        exit)
            echo "Exiting..."
			rendu_path="$root_dir/../../rendu"
			if [[ -d "$rendu_path" && "$rendu_path" == *"/rendu" ]]; then
				rm -rf "$rendu_path"
			fi
            exit 0
            ;;
        *)
            echo "Please type 'test' to test code, 'next' for next or 'exit' for exit."
            ;;
    esac
done
