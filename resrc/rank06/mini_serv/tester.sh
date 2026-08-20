#!/bin/bash

# Color codes
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}🔍 Running tests for mini_serv${NC}"
echo "=========================================="
echo ""

# Check if user file exists
USER_C="../../../rendu/mini_serv/mini_serv.c"

if [ ! -f "$USER_C" ]; then
    echo -e "${RED}❌ User solution not found: $USER_C${NC}"
    exit 1
fi

# Test 1: Check C syntax by compilation
echo -e "${BLUE}📦 Test 1: Checking compilation...${NC}"
gcc -Wall -Wextra -Werror -c "$USER_C" -o temp_mini_serv.o 2>&1

if [ $? -ne 0 ]; then
    echo -e "${RED}❌ Compilation failed!${NC}"
    echo -e "${YELLOW}Please check your C syntax.${NC}"
    rm -f temp_mini_serv.o 2>/dev/null
    exit 1
fi

echo -e "${GREEN}✅ Compilation successful!${NC}"
echo ""

# Test 2: Check for required functions
echo -e "${BLUE}📦 Test 2: Checking for required functions...${NC}"

required_funcs=("socket" "bind" "listen" "accept" "select" "recv" "send" "close")
found_count=0

for func in "${required_funcs[@]}"; do
    if grep -q "$func" "$USER_C"; then
        echo -e "${GREEN}✅ Found: $func${NC}"
        ((found_count++))
    else
        echo -e "${YELLOW}⚠️  Missing: $func${NC}"
    fi
done

echo ""
echo -e "${BLUE}Found $found_count / ${#required_funcs[@]} required functions${NC}"
echo ""

# Test 3: Check for signal handling (SIGINT)
echo -e "${BLUE}📦 Test 3: Checking for signal handling...${NC}"

if grep -q "signal\|SIGINT\|SIGTERM" "$USER_C"; then
    echo -e "${GREEN}✅ Signal handling detected${NC}"
else
    echo -e "${YELLOW}⚠️  No signal handling found (required for clean shutdown)${NC}"
fi

echo ""

# Test 4: Check for non-blocking I/O patterns
echo -e "${BLUE}📦 Test 4: Checking for non-blocking patterns...${NC}"

if grep -q "fcntl\|O_NONBLOCK\|F_SETFL\|select\|FD_SET" "$USER_C"; then
    echo -e "${GREEN}✅ Non-blocking I/O patterns detected${NC}"
else
    echo -e "${YELLOW}⚠️  No non-blocking patterns found (required for multiple clients)${NC}"
fi

echo ""

# Test 5: Check for memory management
echo -e "${BLUE}📦 Test 5: Checking for memory management...${NC}"

if grep -q "malloc\|calloc\|realloc\|free" "$USER_C"; then
    echo -e "${GREEN}✅ Memory management functions detected${NC}"
else
    echo -e "${YELLOW}⚠️  No dynamic memory allocation found${NC}"
fi

echo ""

# Cleanup
rm -f temp_mini_serv.o 2>/dev/null

# Final report
echo "=========================================="
echo -e "${GREEN}$(tput bold)PASSED 🎉$(tput sgr 0)${NC}"
echo -e "${BLUE}Your code compiles successfully!${NC}"
echo -e "${YELLOW}Next steps:${NC}"
echo "  - Bind to 127.0.0.1:PORT"
echo "  - Accept client connections"
echo "  - Use select() for non-blocking operations"
echo "  - Relay messages between clients (client X: message)"
echo "  - Handle client connect/disconnect notifications"
echo "  - Prevent memory/fd leaks"
echo ""

exit 0
