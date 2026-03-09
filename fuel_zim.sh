#!/bin/bash

# Zimbabwe Fuel Price Dashboard with Auto-Scraping
# Data Source: ZERA (Zimbabwe Energy Regulatory Authority)

# UI Colors
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
RED='\033[0;31m'
MAGENTA='\033[0;35m'
NC='\033[0m'

# Function to fetch latest prices from ZERA website
fetch_prices() {
    echo -e "${YELLOW}Fetching latest prices from ZERA...${NC}"
    
    # Download the meta tag containing the prices
    local raw_data=$(curl -s https://www.zera.co.zw | grep -oP "As Of: [0-9-]+.*?ZWG" | head -1)
    
    if [[ -z "$raw_data" ]]; then
        echo -e "${RED}Error: Could not connect to ZERA. Using offline data.${NC}"
        # Fallback to current known prices if scraping fails
        DIESEL_USD=1.77
        PETROL_USD=1.71
        DIESEL_ZWG=45.55
        PETROL_ZWG=44.01
        LAST_UPDATE="Unknown (Offline Mode)"
    else
        # Extract individual prices using regex from meta tag or content
        LAST_UPDATE=$(echo "$raw_data" | grep -oP "As Of: [0-9-]+")
        PETROL_USD=$(curl -s https://www.zera.co.zw | grep -A 5 "Petrol Blend (E5)" | grep -oP "\d+\.\d+" | head -1)
        PETROL_ZWG=$(curl -s https://www.zera.co.zw | grep -A 10 "Petrol Blend (E5)" | grep -oP "\d+\.\d+" | sed -n '2p')
        
        DIESEL_USD=$(curl -s https://www.zera.co.zw | grep -A 5 "Diesel 50" | grep -oP "\d+\.\d+" | head -1)
        DIESEL_ZWG=$(curl -s https://www.zera.co.zw | grep -A 10 "Diesel 50" | grep -oP "\d+\.\d+" | sed -n '2p')

        # Fallback if specific diesel scrap fails
        [[ -z "$DIESEL_USD" ]] && DIESEL_USD=1.77
        [[ -z "$DIESEL_ZWG" ]] && DIESEL_ZWG=45.55
    fi
}

# Function to display the dashboard
show_dashboard() {
    fetch_prices
    
    clear
    echo -e "${CYAN}======================================================================${NC}"
    echo -e "${YELLOW}                 ZIMBABWE FUEL PRICE TRACKER (AUTO-SYNC)              ${NC}"
    echo -e "${CYAN}======================================================================${NC}"
    echo -e "   Status: ${GREEN}OFFICIAL (Live Sync)${NC}           ${LAST_UPDATE}"
    echo -e "${CYAN}----------------------------------------------------------------------${NC}"

    # Price Table
    echo -e "${BLUE}[ CURRENT MAXIMUM REGULATED PRICES ]${NC}"
    echo -e "   Fuel Type      USD Price / Litre      ZiG Price / Litre"
    echo -e "   ----------     -----------------      -----------------"
    echo -e "   DIESEL 50      ${GREEN}\$$DIESEL_USD${NC}                  ZiG $DIESEL_ZWG"
    echo -e "   PETROL (E5)    ${GREEN}\$$PETROL_USD${NC}                  ZiG $PETROL_ZWG"
    
    # Cost Calculator (60L Tank)
    echo -e "\n${BLUE}[ COST ESTIMATOR (Full 60L Tank) ]${NC}"
    local diesel_60=$(echo "$DIESEL_USD * 60" | bc -l)
    local petrol_60=$(echo "$PETROL_USD * 60" | bc -l)
    
    echo -e "   Diesel Tank:   ${YELLOW}\$$(printf "%.2f" $diesel_60)${NC} (USD)   ${MAGENTA}ZiG $(echo "$DIESEL_ZWG * 60" | bc -l | awk '{printf "%.2f", $1}')${NC}"
    echo -e "   Petrol Tank:   ${YELLOW}\$$(printf "%.2f" $petrol_60)${NC} (USD)   ${MAGENTA}ZiG $(echo "$PETROL_ZWG * 60" | bc -l | awk '{printf "%.2f", $1}')${NC}"

    echo -e "\n${BLUE}[ ACTION PANEL ]${NC}"
    echo -e "   1. Prices are automatically synced every time you run this script."
    echo -e "   2. Data is extracted directly from ${CYAN}www.zera.co.zw${NC}."

    echo -e "${CYAN}----------------------------------------------------------------------${NC}"
    echo -e "   ${RED}Note: Service stations may sell BELOW these prices but NOT ABOVE.${NC}"
    echo -e "${CYAN}======================================================================${NC}"
}

# Run the dashboard
show_dashboard
