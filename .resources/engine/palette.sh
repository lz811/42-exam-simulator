# Color palette — cold "terminal / hacker console" theme
# (256-colour where the terminal supports it, with safe 8-colour fallback)
FG_BLACK=$(tput setaf 0)
FG_RED=$(tput setaf 1)
FG_GREEN=$(tput setaf 2)
FG_YELLOW=$(tput setaf 3)
FG_BLUE=$(tput setaf 4)
FG_MAGENTA=$(tput setaf 5)
FG_CYAN=$(tput setaf 6)
FG_WHITE=$(tput setaf 15)

BG_BLACK=$(tput setab 0)
BG_RED=$(tput setab 1)
BG_GREEN=$(tput setab 2)
BG_YELLOW=$(tput setab 3)
BG_BLUE=$(tput setab 4)
BG_MAGENTA=$(tput setab 5)
BG_CYAN=$(tput setab 6)
BG_WHITE=$(tput setab 7)

TXT_BOLD=$(tput bold)
TXT_DIM=$(tput dim)
TXT_RESET=$(tput sgr0)

# Extended accent colours (fall back gracefully on 8-colour terminals)
FG_TEAL=$(tput setaf 6 2>/dev/null)
FG_AMBER=$(tput setaf 3 2>/dev/null)
FG_SLATE=$(tput setaf 15 2>/dev/null)
if [ "$(tput colors 2>/dev/null)" -ge 256 ] 2>/dev/null; then
    FG_TEAL=$(tput setaf 44)
    FG_AMBER=$(tput setaf 214)
    FG_SLATE=$(tput setaf 245)
fi
