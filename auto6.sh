ai model training, data privacy laws, remote work tools, online exam system, student productivity hacks, digital note apps, tech startup funding, coding bootcamp review, cyber attack types, password security tips, social media algorithm, content creator tools, video streaming tech, blockchain basics, cloud storage risks, robotics automation, smart home devices, virtual reality uses, future job trends, internet speed testing#!/bin/bash
# -----------------------------------------
# Microsoft Edge Profile Automation Script
# -----------------------------------------

# Ask user for the text to paste into Terminal
read -p "🔹 Enter the text/command to paste in KeywordSearch terminal: " PASTE_TEXT

# Ask user which cycle to start from
read -p "🔹 Enter starting cycle number: " START_CYCLE

# Profiles to exclude
exclude_profiles=(6 24 25 26 32 36)

# Create full profile list (Default + filtered Profile 1–52)
all_profiles=("Default")

for i in {1..55}; do
    skip=false
    for x in "${exclude_profiles[@]}"; do
        if [[ "$i" == "$x" ]]; then
            skip=true
            break
        fi
    done

    if [[ "$skip" == false ]]; then
        all_profiles+=("Profile $i")
    fi
done

# Split profiles into groups of 4, padding last group if needed
profiles=()
total=${#all_profiles[@]}
group_size=4

for ((i=0; i<total; i+=group_size)); do
    group=("${all_profiles[@]:i:group_size}")

    # Pad group if not full
    if (( ${#group[@]} < group_size )); then
        needed=$((group_size - ${#group[@]}))
        for ((j=0; j<needed; j++)); do
            group+=("${all_profiles[$j]}")
        done
    fi

    profiles+=("$(IFS=,; echo "${group[*]}")")
done

# Function to check if "q" was pressed (manual stop)
check_quit() {
    read -t 1 -n 1 key
    if [[ $key == "q" ]]; then
        echo ""
        echo "❌ Script stopped by user (q pressed)."
        exit 0
    fi
}

# Run cycles
cycle_num=1
for group in "${profiles[@]}"; do
    if (( cycle_num < START_CYCLE )); then
        ((cycle_num++))
        continue
    fi

    IFS=',' read -r -a profs <<< "$group"
    echo "🚀 Starting cycle $cycle_num with profiles: ${profs[*]}"

    # 1️⃣ Launch Edge profiles
    for p in "${profs[@]}"; do
        open -na "Microsoft Edge" --args --profile-directory="$p"
        sleep 2
        check_quit
    done
    sleep 3
    check_quit

    # 2️⃣ Verify Edge is running
    if pgrep -x "Microsoft Edge" >/dev/null; then
        echo "🟢 Microsoft Edge is running."
    else
        echo "🔴 Edge did not start! Exiting."
        exit 1
    fi

    # 3️⃣ Arrange windows
    osascript ~/Desktop/ArrangeEdgeWindows.scpt
    check_quit

    # 4️⃣ Wait 10 seconds
    for i in {1..10}; do
        sleep 1
        check_quit
    done

    # 5️⃣ Launch KeywordSearch.app
    open ~/Desktop/KeywordSearch.app
    sleep 5

    # 6️⃣ Type user text into Terminal
    osascript <<EOF
tell application "System Events"
    tell process "Terminal"
        keystroke "$PASTE_TEXT"
        key code 36
        delay 5
    end tell
end tell
tell application "Terminal"
    if (count of windows) > 0 then
        set miniaturized of front window to true
    end if
end tell
EOF
    check_quit

    # 7️⃣ Wait 7 minutes with minute notifier
    for i in {1..7}; do
        sleep 60
        echo "⏱ $i minute(s) passed..."
    done
    echo "✅ 7 minutes wait complete."

    # 8️⃣ Close Edge
    osascript <<EOF
tell application "Microsoft Edge" to quit
EOF
    killall "Microsoft Edge" >/dev/null 2>&1
    sleep 5

    echo "✨ Cycle $cycle_num done: ${profs[*]}"
    echo "---------------------------------------"
    ((cycle_num++))
done

echo "🎉 All cycles completed."