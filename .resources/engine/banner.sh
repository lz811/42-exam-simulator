source palette.sh

# subtle top-to-bottom gradient for the pixel EXAM wordmark
G1=$(tput setaf 44 2>/dev/null)
G2=$(tput setaf 45 2>/dev/null)
G3=$(tput setaf 51 2>/dev/null)
G4=$(tput setaf 87 2>/dev/null)
G5=$(tput setaf 123 2>/dev/null)
G6=$(tput setaf 159 2>/dev/null)

printf "${G1}${TXT_BOLD}%s${TXT_RESET}   ${G1}${TXT_BOLD}%s${TXT_RESET}\n" "███████╗██╗  ██╗ █████╗ ███╗   ███╗" " /\\_/\\ "
printf "${G2}${TXT_BOLD}%s${TXT_RESET}   ${G2}${TXT_BOLD}%s${TXT_RESET}\n" "██╔════╝╚██╗██╔╝██╔══██╗████╗ ████║" "( o.o )"
printf "${G3}${TXT_BOLD}%s${TXT_RESET}   ${G3}${TXT_BOLD}%s${TXT_RESET}\n" "█████╗   ╚███╔╝ ███████║██╔████╔██║" " > ^ < "
printf "${G4}${TXT_BOLD}%s${TXT_RESET}   ${G4}${TXT_BOLD}%s${TXT_RESET}\n" "██╔══╝   ██╔██╗ ██╔══██║██║╚██╔╝██║" "/     \\"
printf "${G5}${TXT_BOLD}%s${TXT_RESET}   ${G5}${TXT_BOLD}%s${TXT_RESET}\n" "███████╗██╔╝ ██╗██║  ██║██║ ╚═╝ ██║" "|     |"
printf "${G6}${TXT_BOLD}%s${TXT_RESET}   ${G6}${TXT_BOLD}%s${TXT_RESET}\n" "╚══════╝╚═╝  ╚═╝╚═╝  ╚═╝╚═╝     ╚═╝" " \\___/ "
printf "${FG_AMBER}${TXT_DIM}%s${TXT_RESET}\n" "  forty-two rank practice // level grind & live trial"
