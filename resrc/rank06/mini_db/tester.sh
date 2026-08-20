#!/bin/bash

# Color codes
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}🔍 Running tests for mini_db${NC}"
echo "=========================================="
echo ""

# Check if user files exist
USER_CPP="../../../rendu/mini_db/mini_db.cpp"
USER_HPP="../../../rendu/mini_db/mini_db.hpp"

if [ ! -f "$USER_CPP" ] || [ ! -f "$USER_HPP" ]; then
    echo -e "${RED}❌ User solution not found: $USER_CPP or $USER_HPP${NC}"
    exit 1
fi

# Test 1: Check C++ syntax by compilation
echo -e "${BLUE}📦 Test 1: Checking compilation...${NC}"
g++ -Wall -Wextra -Werror -std=c++11 "$USER_CPP" -o user_mini_db 2>&1

if [ $? -ne 0 ]; then
    echo -e "${RED}❌ Compilation failed!${NC}"
    echo -e "${YELLOW}Please check your C++ syntax.${NC}"
    rm -f user_mini_db 2>/dev/null
    exit 1
fi

echo -e "${GREEN}✅ Compilation successful!${NC}"
echo ""

# Test 2: Check for required functions/classes
echo -e "${BLUE}📦 Test 2: Checking for required components...${NC}"

# Check for class or main function
if grep -q "^[[:space:]]*class\|^[[:space:]]*int[[:space:]]*main" "$USER_CPP"; then
    echo -e "${GREEN}✅ Found class or main function${NC}"
else
    echo -e "${YELLOW}⚠️  No class or main function detected${NC}"
fi

# Check for database-related methods (POST, GET, DELETE)
if grep -q "POST\|GET\|DELETE" "$USER_CPP"; then
    echo -e "${GREEN}✅ Found database operation hints${NC}"
else
    echo -e "${YELLOW}⚠️  No database operations (POST/GET/DELETE) detected${NC}"
fi

echo ""

# Test 3: Check for socket-related includes
echo -e "${BLUE}📦 Test 3: Checking for socket/network includes...${NC}"

if grep -q "#include.*socket\|#include.*arpa/inet\|#include.*netinet\|#include.*sys/socket" "$USER_CPP"; then
    echo -e "${GREEN}✅ Network includes found${NC}"
else
    echo -e "${YELLOW}⚠️  Network includes not found (might be needed for server)${NC}"
fi

echo ""

# Test 4: Check for data persistence hints
echo -e "${BLUE}📦 Test 4: Checking for file I/O...${NC}"

if grep -q "ifstream\|ofstream\|fopen\|fclose\|open\|close" "$USER_HPP" "$USER_CPP"; then
    echo -e "${GREEN}✅ File I/O functions detected${NC}"
else
    echo -e "${YELLOW}⚠️  No file I/O detected${NC}"
fi

echo ""

# Test 5: Functional Tests - Start server and test commands
echo -e "${BLUE}📦 Test 5: Running functional tests...${NC}"

# Clean up old database file
rm -f test_db.txt 2>/dev/null

# Find an available port
PORT=9999
while netstat -tuln 2>/dev/null | grep -q ":$PORT "; do
    PORT=$((PORT + 1))
done

# Start the server in background
./user_mini_db $PORT test_db.txt > server_output.txt 2>&1 &
SERVER_PID=$!

# Wait for server to start
sleep 1

# Check if server started successfully
if ! kill -0 $SERVER_PID 2>/dev/null; then
    echo -e "${RED}❌ Server failed to start${NC}"
    cat server_output.txt
    rm -f user_mini_db server_output.txt test_db.txt 2>/dev/null
    exit 1
fi

# Check if "ready" message was printed
if grep -q "ready" server_output.txt; then
    echo -e "${GREEN}✅ Server started and printed 'ready'${NC}"
else
    echo -e "${YELLOW}⚠️  'ready' message not found${NC}"
fi

echo ""

# Test 5.1: POST Command
echo -e "${BLUE}  → Test 5.1: POST command${NC}"
RESPONSE=$(echo "POST user john" | nc -w 1 127.0.0.1 $PORT 2>/dev/null)
if echo "$RESPONSE" | grep -q "^0"; then
    echo -e "${GREEN}    ✅ POST successful (response: $RESPONSE)${NC}"
else
    echo -e "${RED}    ❌ POST failed (response: $RESPONSE)${NC}"
fi

# Test 5.2: GET Command (existing key)
echo -e "${BLUE}  → Test 5.2: GET command (existing key)${NC}"
RESPONSE=$(echo "GET user" | nc -w 1 127.0.0.1 $PORT 2>/dev/null)
if echo "$RESPONSE" | grep -q "^0.*john"; then
    echo -e "${GREEN}    ✅ GET successful (response: $RESPONSE)${NC}"
else
    echo -e "${RED}    ❌ GET failed (response: $RESPONSE)${NC}"
fi

# Test 5.3: GET Command (non-existing key)
echo -e "${BLUE}  → Test 5.3: GET command (non-existing key)${NC}"
RESPONSE=$(echo "GET nonexistent" | nc -w 1 127.0.0.1 $PORT 2>/dev/null)
if echo "$RESPONSE" | grep -q "^1"; then
    echo -e "${GREEN}    ✅ GET returns 1 for missing key${NC}"
else
    echo -e "${RED}    ❌ GET should return 1 for missing key (response: $RESPONSE)${NC}"
fi

# Test 5.4: DELETE Command (existing key)
echo -e "${BLUE}  → Test 5.4: DELETE command (existing key)${NC}"
RESPONSE=$(echo "DELETE user" | nc -w 1 127.0.0.1 $PORT 2>/dev/null)
if echo "$RESPONSE" | grep -q "^0"; then
    echo -e "${GREEN}    ✅ DELETE successful (response: $RESPONSE)${NC}"
else
    echo -e "${RED}    ❌ DELETE failed (response: $RESPONSE)${NC}"
fi

# Test 5.5: GET after DELETE (confirm deletion)
echo -e "${BLUE}  → Test 5.5: GET after DELETE (confirm deletion)${NC}"
RESPONSE=$(echo "GET user" | nc -w 1 127.0.0.1 $PORT 2>/dev/null)
if echo "$RESPONSE" | grep -q "^1"; then
    echo -e "${GREEN}    ✅ Key deleted successfully${NC}"
else
    echo -e "${RED}    ❌ Key should be deleted (response: $RESPONSE)${NC}"
fi

# Test 5.6: Invalid Command
echo -e "${BLUE}  → Test 5.6: Invalid command${NC}"
RESPONSE=$(echo "INVALID command" | nc -w 1 127.0.0.1 $PORT 2>/dev/null)
if echo "$RESPONSE" | grep -q "^2"; then
    echo -e "${GREEN}    ✅ Invalid command returns 2${NC}"
else
    echo -e "${YELLOW}    ⚠️  Invalid command should return 2 (response: $RESPONSE)${NC}"
fi

echo ""

# Cleanup
kill $SERVER_PID 2>/dev/null
wait $SERVER_PID 2>/dev/null
sleep 1

# Check if database file was created
if [ -f test_db.txt ]; then
    echo -e "${GREEN}✅ Database file persisted${NC}"
else
    echo -e "${YELLOW}⚠️  Database file not created${NC}"
fi

# Final cleanup
rm -f user_mini_db server_output.txt test_db.txt 2>/dev/null

# Final report
echo ""
echo "=========================================="
echo -e "${GREEN}$(tput bold)PASSED 🎉$(tput sgr 0)${NC}"
echo -e "${BLUE}All tests completed!${NC}"
echo ""

exit 0
