#!/bin/bash

BANNER_STYLE='\e[1;31;42m'
INFO_STYLE='\e[40;38;5;82m'
ACCENT_STYLE='\e[30;48;5;82m'
BLUE='\e[1;34m'
GREEN='\e[1;32m'
RED='\e[1;31m'
NC='\e[0m'

draw_banner() {
    clear
    echo -e "${BANNER_STYLE}######┌──────────────────────────────────────┐##### ${NC}"
    echo -e "${BANNER_STYLE}######│ ▟▀▀▖▛▀▖▞▀▖▛▀▖ ▞▀▖▀▛▘▞▀▖▝▀▖▛▚▀▖ │##### ${NC}"
    echo -e "${BANNER_STYLE}######│ ▌  ▌▙▄▘▛▀ ▌ ▌ ▚▄▘ ▌ ▛▀ ▞▀▌▌▐ ▌ │##### ${NC}"
    echo -e "${BANNER_STYLE}######│ ▝▀▀▘▘ ▘▝▀▘▘ ▘ ▝▀▘ ▘ ▝▀▘▝▀▘▘ ▘ │##### ${NC}"
    echo -e "${BANNER_STYLE}######└──────────────────────────────────────┘##### ${NC}"
    echo -e "${INFO_STYLE}  Linux Edition ${ACCENT_STYLE} https://github.com/Abrahamqb ${NC}"
    echo -e "${ACCENT_STYLE}    Developer Mode   ${INFO_STYLE}  Abrahamqb - 2026 CLI  ${NC}"
    echo
}

draw_banner
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
    exit 1
fi

echo -e "${GREEN}[+] Steam detected in: $S_PATH${NC}"
sleep 1

while true; do
    draw_banner
    echo -e "${BLUE}Steam Path: $S_PATH${NC}\n"
    echo -e "${GREEN}[1] Download and apply patch (Required)${NC}"
    echo -e "${RED}[2] Remove patch${NC}"
    echo -e "${BLUE}[3] Install Millennium (Arch Linux ONLY)${NC}"
    echo -e "${BLUE}[4] Exit${NC}"
    echo -n "Select an option [1-4]: "
    read -r OPTION

    case $OPTION in
        1)
            echo -e "${BLUE}[*] Applying patch...${NC}"
            URL_XINPUT="https://github.com/Abrahamqb/OpenSteam/raw/refs/heads/master/Resources/xinput1_4.dll"
            URL_HID="https://github.com/Abrahamqb/OpenSteam/raw/refs/heads/master/Resources/hid.dll"
            
            if [ ! -w "$S_PATH" ]; then
                echo -e "${RED}[!] Permission denied. Writing to Steam folder failed.${NC}"
                sleep 2
                continue
            fi

            curl -L "$URL_XINPUT" -o "$S_PATH/xinput1_4.dll" --silent
            curl -L "$URL_HID" -o "$S_PATH/hid.dll" --silent
            echo -e "${GREEN}✔ Patch applied successfully!${NC}"
            sleep 2
            ;;
        2)
            echo -e "${BLUE}[*] Removing patch...${NC}"
            rm -f "$S_PATH/xinput1_4.dll" "$S_PATH/hid.dll"
            echo -e "${GREEN}✔ Patch removed successfully!${NC}"
            sleep 2
            ;;
        3)
            if [ ! -f /etc/arch-release ]; then
                echo -e "${RED}[!] Error: This option is only available for Arch Linux/SteamOS.${NC}"
                sleep 3
                continue
            fi

            echo -e "${BLUE}[*] Checking dependencies...${NC}"
            if ! command -v git &> /dev/null; then
                echo -e "${RED}[!] Git is not installed. Install it with: sudo pacman -S git${NC}"
                sleep 3
                continue
            fi

            echo -e "${BLUE}[*] Installing Millennium via AUR...${NC}"
            rm -rf millennium
            git clone https://aur.archlinux.org/millennium.git
            
            if [ -d "millennium" ]; then
                cd millennium
                makepkg -si --noconfirm
                cd ..
                rm -rf millennium
                echo -e "${GREEN}✔ Millennium installed successfully!${NC}"
                echo -e "${RED}[!] Note: Manually download KernelLua at: https://kernelos.org/games/${NC}"
                echo -e "${BLUE}Press any key to return to menu...${NC}"
                read -n 1
            else
                echo -e "${RED}[!] Failed to clone Millennium repository.${NC}"
                sleep 2
            fi
            ;;
        4)
            echo -e "${BLUE}[*] Exiting... Goodbye!${NC}"
            exit 0
            ;;
        *)
            echo -e "${RED}[!] Invalid option.${NC}"
            sleep 1
            ;;
    esac
done
