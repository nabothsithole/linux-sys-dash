#!/bin/bash

# Enhanced System Monitoring Dashboard Script

# --- CONFIGURATION ---
MONITOR_FOLDER="/home/naboth" # Change this to any project folder you want to track
# ---------------------

# Define colors for the UI
GREEN='\033[0;32m'
BLUE='\033[0;34m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
MAGENTA='\033[0;35m'
NC='\033[0m' # No Color

# Function to get Average CPU Temperature
get_temp() {
    local temps=$(cat /sys/class/thermal/thermal_zone*/temp 2>/dev/null)
    if [ -z "$temps" ]; then
        echo "N/A"
    else
        local sum=0
        local count=0
        for t in $temps; do
            if [ "$t" -gt 0 ]; then
                sum=$((sum + t))
                count=$((count + 1))
            fi
        done
        if [ "$count" -gt 0 ]; then
            echo "$((sum / count / 1000))°C"
        else
            echo "N/A"
        fi
    fi
}

# Function to clear the screen and set up the layout
refresh_dashboard() {
    clear
    echo -e "${CYAN}======================================================================${NC}"
    echo -e "${YELLOW}                 ENHANCED REAL-TIME SYSTEM DASHBOARD                  ${NC}"
    echo -e "${CYAN}======================================================================${NC}"
    echo -e "   Time: $(date '+%Y-%m-%d %H:%M:%S')          Uptime: $(uptime -p)"
    echo -e "   CPU Temp: ${RED}$(get_temp)${NC}                      Folder Tracker: ${MAGENTA}$MONITOR_FOLDER${NC}"
    echo -e "${CYAN}----------------------------------------------------------------------${NC}"

    # 1. CPU Section
    echo -e "${BLUE}[ CPU PERFORMANCE ]${NC}"
    CPU_USAGE=$(top -bn1 | grep "Cpu(s)" | awk '{print 100 - $8}')
    echo -ne "   Overall CPU Load: [ "
    BAR_SIZE=40
    NUM_BLOCKS=$(echo "$CPU_USAGE / (100 / $BAR_SIZE)" | bc -l | cut -d. -f1)
    for i in $(seq 1 $BAR_SIZE); do
        if [ $i -le $NUM_BLOCKS ]; then echo -ne "${GREEN}#${NC}"; else echo -ne "."; fi
    done
    echo -e " ] ${YELLOW}${CPU_USAGE}%${NC}"

    # 2. RAM Section
    echo -e "\n${BLUE}[ MEMORY USAGE ]${NC}"
    MEM_TOTAL=$(free -m | awk '/^Mem:/{print $2}')
    MEM_USED=$(free -m | awk '/^Mem:/{print $3}')
    MEM_PERC=$(echo "scale=2; $MEM_USED / $MEM_TOTAL * 100" | bc -l)
    
    echo -ne "   RAM Usage:        [ "
    NUM_BLOCKS_MEM=$(echo "$MEM_PERC / (100 / $BAR_SIZE)" | bc -l | cut -d. -f1)
    for i in $(seq 1 $BAR_SIZE); do
        if [ $i -le $NUM_BLOCKS_MEM ]; then echo -ne "${CYAN}#${NC}"; else echo -ne "."; fi
    done
    echo -e " ] ${YELLOW}${MEM_USED}MB / ${MEM_TOTAL}MB (${MEM_PERC}%)${NC}"

    # 3. Storage & Folder Info
    echo -e "\n${BLUE}[ STORAGE INFO ]${NC}"
    ROOT_SPACE=$(df -h / | awk 'NR==2 {print $3 "/" $2 " used (" $5 ")"}')
    FOLDER_SIZE=$(du -sh "$MONITOR_FOLDER" 2>/dev/null | awk '{print $1}')
    echo -e "   Root Usage:      ${YELLOW}$ROOT_SPACE${NC}"
    echo -e "   Folder Size:     ${MAGENTA}$FOLDER_SIZE${NC} ($MONITOR_FOLDER)"

    # 4. Top Processes Section
    echo -e "\n${BLUE}[ TOP 5 PROCESSES (BY CPU) ]${NC}"
    echo -e "   ${CYAN}PID    USER      %CPU   %MEM   COMMAND${NC}"
    ps aux --sort=-%cpu | head -n 6 | tail -n 5 | awk '{printf "   %-6s %-8s %-6s %-6s %-15s\n", $2, $1, $3, $4, $11}'

    # 5. Network Section
    echo -e "\n${BLUE}[ NETWORK ]${NC}"
    IFACE=$(ip route get 8.8.8.8 | awk '{print $5; exit}')
    RX=$(cat /sys/class/net/$IFACE/statistics/rx_bytes)
    TX=$(cat /sys/class/net/$IFACE/statistics/tx_bytes)
    echo -e "   Interface: ${CYAN}$IFACE${NC}    Received: ${GREEN}$(numfmt --to=iec $RX)${NC}    Sent: ${GREEN}$(numfmt --to=iec $TX)${NC}"

    echo -e "${CYAN}----------------------------------------------------------------------${NC}"
    echo -e "   Press [CTRL+C] to exit..."
}

# Main loop
while true; do
    refresh_dashboard
    sleep 3
done
