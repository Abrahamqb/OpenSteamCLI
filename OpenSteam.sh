#!/bin/bash

BANNER_STYLE='\e[1;31;42m'
INFO_STYLE='\e[40;38;5;82m'
ACCENT_STYLE='\e[30;48;5;82m'
BLUE='\e[1;34m'
GREEN='\e[1;32m'
RED='\e[1;31m'
NC='\e[0m'

clear

echo -e "${BANNER_STYLE}######┌──────────────────────────────────────┐##### ${NC}"
echo -e "${BANNER_STYLE}######│ ▟▀▀▖▛▀▖▞▀▖▛▀▖ ▞▀▖▀▛▘▞▀▖▝▀▖▛▚▀▖ │##### ${NC}"
echo -e "${BANNER_STYLE}######│ ▌  ▌▙▄▘▛▀ ▌ ▌ ▚▄▘ ▌ ▛▀ ▞▀▌▌▐ ▌ │##### ${NC}"
echo -e "${BANNER_STYLE}######│ ▝▀▀▘▘ ▘▝▀▘▘ ▘ ▝▀▘ ▘ ▝▀▘▝▀▘▘ ▘ │##### ${NC}"
echo -e "${BANNER_STYLE}######└──────────────────────────────────────┘##### ${NC}"
echo
echo -e "${INFO_STYLE}  Arch Linux Edition ${ACCENT_STYLE} https://github.com/Abrahamqb ${NC}"
echo -e "${ACCENT_STYLE}    Developer Mode   ${INFO_STYLE}  Abrahamqb - 2026 CLI  ${NC}"
echo

echo -e "${BLUE}[*] Looking for Steam directories on Linux...${NC}"

PATHS=(
    "$HOME/.local/share/Steam/ubuntu12_32"
    "$HOME/.steam/steam/ubuntu12_32"
    "$HOME/.var/app/com.valvesoftware.Steam/.steam/steam/ubuntu12_32"
)

S_PATH=""

for p in "${PATHS[@]}"; do
    if [ -d "$p" ]; then
        S_PATH="$p"
        break
    fi
done

if [ -z "$S_PATH" ]; then
    echo -e "${RED}[!] ERROR: Steam folder not found.${NC}"
    echo -e "${BLUE}[i] Try installing Steam first${NC}"
    exit 1
fi

echo -e "${GREEN}[+]Steam detected in: $S_PATH${NC}"

sleep 1
clear

main(){
    echo -e "${GREEN}[1] Download and apply patch (Required)${NC}"
    echo -e "${GREEN}[2] Remove patch${NC}"
    echo -e "${GREEN}[3] Exit${NC}"
    echo -n "Select an option [1-3]: "
    read OPTION

    case $OPTION in
        1)
            echo -e "${BLUE}[*] Applying patch...${NC}"
            URL_XINPUT="https://github.com/Abrahamqb/OpenSteam/raw/refs/heads/master/Resources/xinput1_4.dll"
            URL_HID="https://github.com/Abrahamqb/OpenSteam/raw/refs/heads/master/Resources/hid.dll"
            echo -e "${BLUE}[*] Downloading...${NC}"
            curl -L "$URL_XINPUT" -o "$S_PATH/xinput1_4.dll" --silent
            curl -L "$URL_HID" -o "$S_PATH/hid.dll" --silent
            ;;
        2)
            echo -e "${BLUE}[*] Removing patch...${NC}"
            rm -f "$S_PATH/xinput1_4.dll" "$S_PATH/hid.dll"
            echo -e "${GREEN}✔ Patch removed successfully!${NC}"
            exit 0
            ;;
        3)
            echo -e "${BLUE}[*] Exiting...${NC}"
            exit 0
            ;;
        *)
            echo -e "${RED}[!] Invalid option. Exiting...${NC}"
            exit 1
            ;;
    esac
}

main