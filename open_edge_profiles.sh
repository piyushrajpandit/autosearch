#!/bin/bash

# Profiles to skip
exclude=(
6 14 16 18 19 24 25 26 32 34 36 37 39 42
50 54 62 63 64 65 66 67 68 69 70 71 72
73 74 75 76 77 81 82 83 84 85 86 87 88 89
)

count=0

echo "Opening Microsoft Edge profiles..."
echo

# Open Default profile first
echo "Opening Default"
open -na "Microsoft Edge" --args --profile-directory="Default"
((count++))

# Pause after every 5 profiles
if (( count % 5 == 0 ))
then
    read -p "Opened 5 profiles. Press Enter to continue..."
fi

for i in {1..99}
do
    skip=false

    for ex in "${exclude[@]}"
    do
        if [ "$i" -eq "$ex" ]; then
            skip=true
            break
        fi
    done

    if [ "$skip" = true ]; then
        continue
    fi

    echo "Opening Profile $i"
    open -na "Microsoft Edge" --args --profile-directory="Profile $i"

    ((count++))

    # Pause after every 5 opened profiles
    if (( count % 5 == 0 ))
    then
        echo
        read -p "Opened 5 profiles. Press Enter to continue..."
        echo
    fi
done

echo
echo "All eligible profiles opened."