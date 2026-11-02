#!/bin/bash

# Project paths
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
DATA="$DIR/data/questions.csv"
HISTORY="$DIR/reports/results.csv"
WRONG="$DIR/reports/wrong.txt"

# Create required folders and files
mkdir -p "$DIR/data" "$DIR/reports" "$DIR/backups" "$DIR/logs"
touch "$HISTORY" "$WRONG" "$DIR/logs/activity.log"

# Record activity
log() {
    echo "$(date) $1" >> "$DIR/logs/activity.log"
}

# Start quiz
quiz() {
    read -r -p "Enter your name: " name

    if [[ -z "$name" ]]; then
        echo "Name is required!"
        return 1
    fi

    score=0
    wrong=""
    start=$SECONDS

    # Select five random questions, excluding the CSV header
    mapfile -t questions < <(tail -n +2 "$DATA" | shuf -n 5)

    if [[ ${#questions[@]} -eq 0 ]]; then
        echo "No questions found in questions.csv!"
        return 1
    fi

    total=${#questions[@]}

    for row in "${questions[@]}"; do
        IFS=',' read -r q a b c d ans <<< "$row"

        # Clean Windows line endings and whitespace
        q="${q//$'\r'/}"
        a="${a//$'\r'/}"
        b="${b//$'\r'/}"
        c="${c//$'\r'/}"
        d="${d//$'\r'/}"
        ans="${ans//$'\r'/}"

        # Remove whitespace from the correct answer
        ans="$(printf '%s' "$ans" | tr -d '[:space:]')"
        ans="${ans^^}"

        echo
        echo "$q"
        echo "A) $a"
        echo "B) $b"
        echo "C) $c"
        echo "D) $d"

        read -r -p "Your answer (A/B/C/D): " choice

        # Normalize the user's answer
        choice="$(printf '%s' "$choice" | tr -d '[:space:]')"
        choice="${choice^^}"

        # Validate the answer
        if [[ "$choice" != "A" && "$choice" != "B" &&
              "$choice" != "C" && "$choice" != "D" ]]; then
            echo "Invalid option! Please enter A, B, C, or D."
            echo "Correct answer: $ans"
            wrong+="$q | Your answer: $choice | Correct: $ans"$'\n'
        elif [[ "$choice" == "$ans" ]]; then
            echo "Correct!"
            ((score++))
        else
            echo "Wrong! Correct answer: $ans"
            wrong+="$q | Your answer: $choice | Correct: $ans"$'\n'
        fi
    done

    # Calculate score and time
    elapsed=$((SECONDS - start))
    percent=$((score * 100 / total))

    echo
    echo "========== QUIZ RESULT =========="
    echo "Player: $name"
    echo "Score: $score/$total"
    echo "Percentage: $percent%"
    echo "Time: $elapsed seconds"
    echo "================================="

    # Save quiz result
    printf '%s,%s,%s,%s,%s\n' \
        "$(date)" "$name" "$score" "$percent" "$elapsed" >> "$HISTORY"

    # Save only the wrong answers from the latest quiz
    if [[ -n "$wrong" ]]; then
        printf '%s' "$wrong" > "$WRONG"
    else
        echo "No wrong answers! Excellent work, $name!" > "$WRONG"
    fi

    log "Quiz completed by $name: $score/$total"
}

# View recent quiz results
timing() {
    echo "Recent quiz results:"
    if [[ -s "$HISTORY" ]]; then
        tail -n 10 "$HISTORY"
    else
        echo "No quiz results available yet."
    fi
}

# View scores, highest score first
scores() {
    echo "Scores:"
    if [[ -s "$HISTORY" ]]; then
        sort -t',' -k3,3nr "$HISTORY"
    else
        echo "No scores available yet."
    fi
}

# Search player history
history() {
    read -r -p "Enter player name: " name

    if [[ -z "$name" ]]; then
        echo "Name is required!"
        return 1
    fi

    if ! grep -iF -- "$name" "$HISTORY"; then
        echo "No results found for $name."
    fi
}

# Review wrong answers from the latest quiz
review() {
    if [[ -s "$WRONG" ]]; then
        cat "$WRONG"
    else
        echo "No wrong answers recorded."
    fi
}

# View all questions
view_data() {
    if [[ -f "$DATA" ]]; then
        cat -n "$DATA"
    else
        echo "Questions file not found!"
    fi
}

# Create a compressed backup
backup() {
    mkdir -p "$DIR/backups"

    local backup_file
    backup_file="$DIR/backups/backup_$(date +%Y%m%d_%H%M%S).tar.gz"

    if tar -czf "$backup_file" -C "$DIR" data reports logs; then
        echo "Backup created successfully!"
        log "Backup created: $backup_file"
    else
        echo "Backup failed! Please check the error above."
        log "Backup failed"
        return 1
    fi
}

# Generate question of the day
cron_task() {
    if [[ ! -f "$DATA" ]]; then
        echo "Questions file not found!"
        return 1
    fi

    local question
    question="$(tail -n +2 "$DATA" | shuf -n 1)"

    if [[ -z "$question" ]]; then
        echo "No questions available!"
        return 1
    fi

    printf '%s\n' "$question" > "$DIR/qotd.txt"

    echo "Question of the day saved to qotd.txt"
    log "Question of the day generated"
}

# View recent activity
view_log() {
    if [[ -s "$DIR/logs/activity.log" ]]; then
        tail -n 20 "$DIR/logs/activity.log"
    else
        echo "No activity logs available."
    fi
}