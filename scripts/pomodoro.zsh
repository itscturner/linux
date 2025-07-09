#!/bin/zsh

WORK=1500           # 25 Minutes
SHORT_BREAK=300     # 5 Minutes
LONG_BREAK=900      # 15 Minutes
UPDATE_INTERVAL=30  # Update progress bar every 30 seconds

TERM_WIDTH=$(tput cols)
BAR_WIDTH=$((TERM_WIDTH - 40))

pomodoro() {
    TOTAL_SECONDS=$1
    sleep 1

    for ((elapsed=0; elapsed<=TOTAL_SECONDS; elapsed++)); do
        local remaining=$((TOTAL_SECONDS - elapsed))

        local minutes=$((remaining / 60))
        local seconds=$((remaining % 60))
        local time_left
        time_left=$(printf "%02d:%02d" "$minutes" "$seconds")

        local percent=$(( (100 * elapsed) / TOTAL_SECONDS ))
        local filled=$(( (BAR_WIDTH * percent) / 100 ))
        local empty=$(( BAR_WIDTH - filled ))

        local bar
        bar=$(printf "%${filled}s" | tr ' ' '#')
        bar+=$(printf "%${empty}s")

        printf "\r[%s] %3d%% | Time Left: %s" "$bar" "$percent" "$time_left"

        sleep 1
    done
}

while test $# -gt 0; do
  case "$1" in
    -h)
      echo ""
      echo "  Usage: $0 [ OPTION ]"
      echo "  Options:"
      echo "    -w,--work        |  Start a work session."
      echo "    -s,--shortbreak  |  Start a short break session."
      echo "    -l,--longbreak   |  Start a long break session."
      echo "    -h,--help        |  Display help."
      echo ""
      exit 0
      ;;
    -w|--work)
      echo "Starting a work session."
      echo ""
      sleep 1
      pomodoro $WORK
      echo ""
      echo -e "\a"
      echo -e "\n✅ Work session complete! Time for a break."
      exit 0
      ;;
    -s|--shortbreak)
      echo "Starting a short break session!"
      echo ""
      pomodoro $SHORT_BREAK
      echo ""
      echo -e "\a"
      echo -e "\nShort break session complete. Back to work."
      exit 0
      ;;
    -l|--longbreak)
      echo "Starting a long break session!"
      echo ""
      pomodoro $LONG_BREAK
      echo ""
      echo -e "\a"
      echo -e "\nShort break session complete. Back to work."
      exit 0
      ;;
    *)
      echo "  Invalid option, exiting..."
      echo "  Try: $0 -h"
      echo ""
      exit 1
      ;;
  esac
done
