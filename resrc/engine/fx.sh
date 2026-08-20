#!/bin/bash

spin_frames=("◐" "◓" "◑" "◒")
spin_delay=0.1
spin_rounds=3

wipe_screen() {
    printf "\033c"
}

spin_wait() {
    for round in $(seq 1 $spin_rounds); do
        for frame in "${spin_frames[@]}"; do
            wipe_screen
            printf "$(tput setaf 2)$(tput bold)Please wait... %s\n\n" "$frame"
            sleep $spin_delay
            tput sgr0
        done
        tput sgr0
    done
    tput sgr0
}

# progress_bar <current> <total> [label]
# Draws a segmented progress meter with percentage, e.g.:
#   RANK02  ▰▰▰▰▰▰▰▰▱▱▱▱▱▱▱▱▱▱▱▱  33%
progress_bar() {
    local current=$1
    local total=$2
    local label=${3:-PROGRESS}
    local width=20

    if [ -z "$total" ] || [ "$total" -le 0 ]; then
        return
    fi

    local filled=$(( current * width / total ))
    [ "$filled" -gt "$width" ] && filled=$width
    local empty=$(( width - filled ))
    local pct=$(( current * 100 / total ))

    local bar=""
    for ((i = 0; i < filled; i++)); do bar+="▰"; done
    for ((i = 0; i < empty; i++)); do bar+="▱"; done

    local bar_color
    if [ "$pct" -ge 100 ]; then
        bar_color=$(tput setaf 42)
    elif [ "$pct" -ge 50 ]; then
        bar_color=$(tput setaf 214)
    else
        bar_color=$(tput setaf 45)
    fi

    printf "$(tput setaf 15)$(tput bold)%-8s$(tput sgr0) %s%s$(tput sgr0) $(tput setaf 245)%3s%%$(tput sgr0)\n" "$label" "$bar_color" "$bar" "$pct"
}

# progress_header <current> <total> [label]
# Persistent status banner: progress bar + a thin separator underneath it.
# Meant to be redrawn at the top of the screen every time the exercise
# loop refreshes, so the candidate always sees where they are in the exam.
progress_header() {
    progress_bar "$1" "$2" "$3"
    printf "$(tput setaf 238)%s$(tput sgr0)\n" "────────────────────────────────────────────────────"
}

# epic_praise
# Prints one absurdly over-the-top, self-important line celebrating the
# candidate as though they had just single-handedly solved computer
# science forever. Picked at random each time it's called.
epic_praise() {
    local lines=(
        "Historians will one day argue about whether this exact moment was the true birth of modern computing."
        "Somewhere, a bronze statue is already being commissioned in your honor."
        "The compiler itself just paused to applaud."
        "Silicon Valley will rename a street after this keystroke."
        "Future generations will study this solution in reverent, hushed classrooms."
        "Donald Knuth just felt a disturbance, as if a thousand textbooks sighed in awe."
        "This code should be preserved under glass in a museum, guarded, lightly humidified."
        "The Turing Award committee has been notified. They are, frankly, nervous."
        "Somewhere a rubber duck just retired, its life's purpose fulfilled."
        "Legends will be told of this exact terminal, on this exact day."
        "Even the machine spirit inside your CPU briefly wept tears of pure binary joy."
        "This is, objectively and without exaggeration, the greatest thing anyone has ever typed."
    )
    local n=${#lines[@]}
    local idx=$(( RANDOM % n ))
    echo "${lines[$idx]}"
}
