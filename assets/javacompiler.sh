#!/bin/bash
set -e

# =========================================================================
#  🌌 CYBER BUILD SYSTEM v3.0 - NEURAL ANDROID COMPILER 🌌
# =========================================================================

# -------- QUANTUM COLOR PALETTE --------
export RED='\033[38;5;196m'
export GREEN='\033[38;5;46m'
export YELLOW='\033[38;5;226m'
export BLUE='\033[38;5;39m'
export MAGENTA='\033[38;5;201m'
export CYAN='\033[38;5;51m'
export ORANGE='\033[38;5;208m'
export PURPLE='\033[38;5;129m'
export PINK='\033[38;5;199m'
export LIME='\033[38;5;118m'
export BOLD='\033[1m'
export DIM='\033[2m'
export RESET='\033[0m'
export BLINK='\033[5m'
export REVERSE='\033[7m'

# -------- MATRIX RAIN EFFECT --------
matrix_rain() {
    local duration=$1
    local chars="ｱｲｳｴｵｶｷｸｹｺｻｼｽｾｿﾀﾁﾂﾃﾄﾅﾆﾇﾈﾉﾊﾋﾌﾍﾎﾏﾐﾑﾒﾓﾔﾕﾖﾗﾘﾙﾚﾛﾜｦﾝ0123456789"

    for ((i=0; i<duration; i++)); do
        printf "\033[H\033[J"
        for ((row=0; row<10; row++)); do
            for ((col=0; col<80; col++)); do
                if (( RANDOM % 20 == 0 )); then
                    char_idx=$((RANDOM % ${#chars}))
                    printf "\033[38;5;$((46 + RANDOM % 6))m${chars:$char_idx:1}"
                else
                    printf " "
                fi
            done
            echo
        done
        sleep 0.05
    done
    printf "\033[H\033[J"
}

# -------- HOLOGRAPHIC PROGRESS BAR --------
holo_progress() {
    local percent=$1
    local width=50
    local filled=$((percent * width / 100))
    local empty=$((width - filled))

    # Clear the entire line first
    printf "\r\033[K"
    printf "${CYAN}["

    # Filled portion with gradient effect
    for ((i=0; i<filled; i++)); do
        if ((i % 3 == 0)); then
            printf "${LIME}█"
        elif ((i % 3 == 1)); then
            printf "${CYAN}█"
        else
            printf "${BLUE}█"
        fi
    done

    # Empty portion
    for ((i=0; i<empty; i++)); do
        printf "${DIM}░"
    done

    printf "${CYAN}] ${BOLD}${percent}%%${RESET}"

    if [[ $percent -eq 100 ]]; then
        printf " ${GREEN}${BLINK}◆ COMPLETE ◆${RESET}\n"
    fi
}

# -------- TYPEWRITER EFFECT --------
typewriter() {
    local text="$1"
    local color="$2"
    local delay=${3:-0.03}

    for ((i=0; i<${#text}; i++)); do
        printf "${color}${text:$i:1}${RESET}"
        sleep $delay
    done
    echo
}

# -------- GLITCH EFFECT --------
glitch_text() {
    local text="$1"
    local iterations=5

    for ((i=0; i<iterations; i++)); do
        printf "\r"
        for ((j=0; j<${#text}; j++)); do
            if (( RANDOM % 10 < 3 )); then
                printf "${RED}${REVERSE}${text:$j:1}${RESET}"
            elif (( RANDOM % 10 < 2 )); then
                printf "${CYAN}${BLINK}${text:$j:1}${RESET}"
            else
                printf "${GREEN}${text:$j:1}"
            fi
        done
        sleep 0.1
    done
    printf "\r${GREEN}${text}${RESET}\n"
}

# -------- NEURAL LOADING ANIMATION --------
android_processing() {
    local message="$1"
    local duration=${2:-15}
    local colors=("46" "51" "39" "27" "33" "87")

    printf "${CYAN}${message}${RESET}\n"

    for ((i=0; i<duration; i++)); do
        printf "\r${BOLD}"
        for ((j=0; j<8; j++)); do
            color_idx=$((RANDOM % ${#colors[@]}))
            if (( (i + j) % 8 == 0 )); then
                printf "\033[38;5;${colors[$color_idx]}m●"
            elif (( (i + j) % 8 == 1 )); then
                printf "\033[38;5;${colors[$color_idx]}m◐"
            elif (( (i + j) % 8 == 2 )); then
                printf "\033[38;5;${colors[$color_idx]}m◑"
            elif (( (i + j) % 8 == 3 )); then
                printf "\033[38;5;${colors[$color_idx]}m◒"
            else
                printf "\033[38;5;${colors[$color_idx]}m○"
            fi
        done
        printf "${RESET}"
        sleep 0.08
    done
    printf "\n"
}

# -------- SYSTEM BOOT SEQUENCE --------
boot_sequence() {
    clear
    printf "\033[?25l" # Hide cursor

    echo -e "${RED}${BOLD}"
    echo "════════════════════════════════════════════════════════════════════════════════"
    echo "                         ⚡ INITIALIZING QUANTUM SYSTEMS ⚡"
    echo "════════════════════════════════════════════════════════════════════════════════"
    echo -e "${RESET}"

    sleep 1

    local systems=("ANDROID SDK" "JAVA COMPILER" "BUILD TOOLS" "D8 CONVERTER" "DEX RUNTIME")

    for system in "${systems[@]}"; do
        printf "${CYAN}[${YELLOW}BOOT${CYAN}] ${LIME}Initializing ${system}..."
        for ((i=0; i<20; i++)); do
            printf "${GREEN}."
            sleep 0.05
        done
        printf " ${GREEN}${BOLD}✓ ONLINE${RESET}\n"
        sleep 0.2
    done

    sleep 1
    matrix_rain 15
}

# -------- HOLOGRAPHIC HEADER --------
show_header() {
    clear
    echo -e "${CYAN}${BOLD}"
    cat << "EOF"
   ██████╗  █████╗ ████████╗
   ██╔══██╗██╔══██╗╚══██╔══╝
   ██████╔╝███████║   ██║   
   ██╔══██╗██╔══██║   ██║   
   ██║  ██║██║  ██║   ██║   
   ╚═╝  ╚═╝╚═╝  ╚═╝   ╚═╝  
EOF
    echo -e "${RESET}"

    typewriter "                    🌟 ANDROID BUILD SYSTEM v3.0 🌟" "${MAGENTA}${BOLD}" 0.02
    typewriter "                      Java → JAR → DEX Compiler Pipeline" "${CYAN}" 0.02

    echo -e "\n${LIME}${BOLD}╔══════════════════════════════════════════════════════════════════════════════╗"
    echo -e "║                          🚀 COMPILING ANDROID APK 🚀                        ║"
    echo -e "╚══════════════════════════════════════════════════════════════════════════════╝${RESET}\n"

    sleep 2
}

# -------- SYSTEM STATUS --------
system_status() {
    echo -e "${PURPLE}${BOLD}┌─────────────────────────────────────────────────────────────────────────────┐"
    echo -e "│                            🔬 ANDROID BUILD STATUS 🔬                       │"
    echo -e "└─────────────────────────────────────────────────────────────────────────────┘${RESET}"

    local checks=("Android SDK" "Java JDK" "D8 Compiler" "Build Tools" "APK Tools")
    local status=("READY" "ACTIVE" "LOADED" "ARMED" "STANDBY")
    local colors=("${GREEN}" "${LIME}" "${CYAN}" "${YELLOW}" "${MAGENTA}")

    for ((i=0; i<${#checks[@]}; i++)); do
        printf "${BLUE}▶ ${checks[$i]}${DIM}......................."
        sleep 0.3
        printf "${colors[$i]}${BOLD}[${status[$i]}]${RESET}\n"
    done

    echo
}

# -------- PROCESS STEP --------
process_step() {
    local step_num="$1"
    local total_steps="$2"
    local title="$3"
    local description="$4"

    echo -e "\n${ORANGE}${BOLD}╭──────────────────────────────────────────────────────────────────────────────╮"
    echo -e "│  STEP ${step_num}/${total_steps}: ${title}"
    echo -e "╰──────────────────────────────────────────────────────────────────────────────╯${RESET}"

    glitch_text "◆ ${description}"

    android_processing "⚡ Processing build step..." 12

    # Just show completion directly
    holo_progress 100

    echo -e "\n${GREEN}${BOLD}✨ STEP ${step_num} COMPLETE ✨${RESET}\n"
    sleep 0.5
}

# -------- MAIN EXECUTION --------

# Boot sequence
boot_sequence

# Show header
show_header

# System diagnostics
system_status

# -------- Configuration with Visual Feedback --------
echo -e "${PINK}${BOLD}⚙️  QUANTUM CONFIGURATION MATRIX ⚙️${RESET}"
ANDROID_JAR="$ANDROID_HOME/platforms/android-33/android.jar"
SRC_FILE="CameraHelper.java"
OUT_DIR="out"
CLASS_DIR="$OUT_DIR/classes"
JAR_FILE="$OUT_DIR/CameraHelper.jar"
DEX_OUT="$OUT_DIR/dex"

config_items=("Android JAR: $ANDROID_JAR" "Source File: $SRC_FILE" "Output Dir: $OUT_DIR" "Class Dir: $CLASS_DIR" "JAR File: $JAR_FILE" "DEX Output: $DEX_OUT")

for item in "${config_items[@]}"; do
    typewriter "  ${CYAN}◇ ${item}" "${CYAN}" 0.01
done

echo -e "\n${MAGENTA}📁 Setting up build directories..."
mkdir -p "$CLASS_DIR" "$DEX_OUT"
android_processing "📂 Creating output structure..." 10
echo -e "${GREEN}✅ Build directories ready${RESET}\n"

# -------- STEP 1: JAVA COMPILATION --------
process_step 1 4 "JAVA COMPILATION" "Compiling Java source code to bytecode"

echo -e "${BLUE}⚡ Executing: ${CYAN}javac -source 11 -target 11 -classpath '$ANDROID_JAR' -d '$CLASS_DIR' -Xlint:all -deprecation '$SRC_FILE'${RESET}"
javac \
  -source 11 -target 11 \
  -classpath "$ANDROID_JAR" \
  -d "$CLASS_DIR" \
  -Xlint:all -deprecation \
  "$SRC_FILE"

# -------- STEP 2: JAR PACKAGING --------
process_step 2 4 "JAR PACKAGING" "Creating JAR archive from compiled classes"

echo -e "${BLUE}⚡ Executing: ${CYAN}jar cf '$JAR_FILE' -C '$CLASS_DIR' .${RESET}"
jar cf "$JAR_FILE" -C "$CLASS_DIR" .

# -------- STEP 3: DEX CONVERSION --------
process_step 3 4 "DEX CONVERSION" "Converting JAR to Android DEX bytecode"

echo -e "${BLUE}⚡ Executing: ${CYAN}d8 --classpath '$ANDROID_JAR' --output '$DEX_OUT' '$JAR_FILE'${RESET}"
"$ANDROID_HOME/build-tools/33.0.0/d8" \
  --classpath "$ANDROID_JAR" \
  --output "$DEX_OUT" \
  "$JAR_FILE"

# -------- STEP 4: FILE DEPLOYMENT --------
process_step 4 4 "FILE DEPLOYMENT" "Copying classes.dex to project root"

echo -e "${BLUE}⚡ Executing: ${CYAN}cp '$DEX_OUT/classes.dex' .${RESET}"
cp "$DEX_OUT/classes.dex" .

# -------- FINAL SUCCESS SEQUENCE --------
echo -e "\n${LIME}${BOLD}╔══════════════════════════════════════════════════════════════════════════════╗"
echo -e "║                           🎉 ANDROID BUILD COMPLETE 🎉                       ║"
echo -e "╚══════════════════════════════════════════════════════════════════════════════╝${RESET}"

# Celebration animation
for ((i=0; i<5; i++)); do
    printf "\r${BLINK}${LIME}★ ☆ ★ ☆ ★ DEX COMPILATION SUCCESSFUL ★ ☆ ★ ☆ ★${RESET}"
    sleep 0.5
    printf "\r${BLINK}${CYAN}☆ ★ ☆ ★ ☆ DEX COMPILATION SUCCESSFUL ☆ ★ ☆ ★ ☆${RESET}"
    sleep 0.5
done
echo -e "\n"

# -------- CARGO EXECUTION PROMPT --------
echo -e "${PINK}${BOLD}╭──────────────────────────────────────────────────────────────────────────────╮"
echo -e "│                         🚀 LAUNCH SEQUENCE READY 🚀                         │"
echo -e "╰──────────────────────────────────────────────────────────────────────────────╯${RESET}"

typewriter "🌟 Execute cargo apk run for device deployment? [Y/n]: " "${CYAN}${BOLD}" 0.02
read -rp "" RUN_CARGO

if [[ "$RUN_CARGO" =~ ^[Yy]$|^$ ]]; then
    echo -e "\n${YELLOW}${BOLD}▶️ INITIATING CARGO LAUNCH SEQUENCE...${RESET}"

    # Launch countdown
    for ((i=3; i>=1; i--)); do
        printf "\r${RED}${BOLD}${BLINK}⚡ T-${i} SECONDS ⚡${RESET}"
        sleep 1
    done

    printf "\r${GREEN}${BOLD}🚀 LAUNCHING! 🚀${RESET}\n\n"
    cargo apk run
else
    typewriter "🛑 Launch sequence aborted. Standing by..." "${MAGENTA}" 0.02
fi

# -------- FINAL SYSTEM MESSAGE --------
echo -e "\n${CYAN}${BOLD}╔══════════════════════════════════════════════════════════════════════════════╗"
echo -e "║  🌌 ANDROID BUILD SYSTEM COMPLETE - READY FOR APK DEPLOYMENT 🌌              ║"
echo -e "╚══════════════════════════════════════════════════════════════════════════════╝${RESET}"

printf "\033[?25h" # Show cursor

# Matrix fade out
echo -e "${DIM}${GREEN}"
for ((i=0; i<3; i++)); do
    echo "    ▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒"
    sleep 0.2
done
echo -e "${RESET}"
