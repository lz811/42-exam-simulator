#!/bin/bash

# Palette
hueRed='\033[0;31m'
hueGreen='\033[0;32m'
hueYellow='\033[1;33m'
hueBlue='\033[0;34m'
hueCyan='\033[0;36m'
hueBold='\033[1m'
hueOff='\033[0m'

clear

echo -e "${hueCyan}"
echo "╔═══════════════════════════════════════════════════════════╗"
echo "║                      SYNCING REPOSITORY                     ║"
echo "╚═══════════════════════════════════════════════════════════╝"
echo -e "${hueOff}"
echo ""

if ! command -v git &> /dev/null; then
    echo -e "${hueRed}Error: Git is not installed${hueOff}"
    exit 1
fi

if ! git rev-parse --git-dir > /dev/null 2>&1; then
    echo -e "${hueRed}Error: Not in a git repository${hueOff}"
    exit 1
fi

branchNow=$(git rev-parse --abbrev-ref HEAD)
echo -e "${hueBlue}Current branch: ${hueYellow}$branchNow${hueOff}"
echo ""

echo -e "${hueBlue}Fetching latest changes from repository...${hueOff}"
if ! git fetch origin; then
    echo -e "${hueRed}Failed to fetch${hueOff}"
    exit 1
fi
echo -e "${hueGreen}Fetch successful${hueOff}"
echo ""

behindCount=$(git rev-list --count HEAD..origin/$branchNow 2>/dev/null)

if [ "$behindCount" -eq 0 ]; then
    echo -e "${hueGreen}Up to date.${hueOff}"
    echo ""
else
    echo -e "${hueYellow}$behindCount update(s) available${hueOff}"
    echo ""

    echo -e "${hueBlue}Changes to be pulled:${hueOff}"
    git log HEAD..origin/$branchNow --oneline | sed 's/^/   /'
    echo ""

    echo -e "${hueBlue}Pulling latest changes...${hueOff}"
    if ! git pull origin $branchNow; then
        echo -e "${hueRed}Failed to pull${hueOff}"
        exit 1
    fi
    echo -e "${hueGreen}Pull successful${hueOff}"
    echo ""
fi

echo -e "${hueBlue}Updating file permissions...${hueOff}"
find .resources -name "tester.sh" -exec chmod +x {} \; 2>/dev/null
echo -e "${hueGreen}Permissions updated${hueOff}"
echo ""

echo "═══════════════════════════════════════════════════════════"
echo -e "${hueGreen}${hueBold}Sync Complete.${hueOff}"
echo "═══════════════════════════════════════════════════════════"
echo ""
echo -e "${hueCyan}Ready to continue? Press enter to return to menu.${hueOff}"
read -r

cd .resources/engine
bash home.sh
