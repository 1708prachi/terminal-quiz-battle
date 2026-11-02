#!/bin/bash

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$DIR/lib/functions.sh"

mkdir -p "$DIR/data" "$DIR/reports" "$DIR/logs" "$DIR/backups"

if [[ ! -s "$DIR/reports/results.csv" ]]; then
    echo "Date,Name,Score,Percentage,Time" > "$DIR/reports/results.csv"
fi

case "$1" in
    --help)
        echo "Usage: ./main.sh [--help|--backup|--cron]"
        exit 0
        ;;
    --backup)
        backup
        exit 0
        ;;
    --cron)
        cron_task
        exit 0
        ;;
esac

while true; do
    echo
    echo "===== TERMINAL QUIZ BATTLE ====="
    echo "1. Start Quiz"
    echo "2. View Recent Results"
    echo "3. View All Scores"
    echo "4. Search Player History"
    echo "5. Review Wrong Answers"
    echo "6. View Questions"
    echo "7. Create Backup"
    echo "8. View Activity Log"
    echo "0. Exit"

    read -r -p "Choose an option: " choice

    case "$choice" in
        1) quiz ;;
        2) timing ;;
        3) scores ;;
        4) history ;;
        5) review ;;
        6) view_data ;;
        7) backup ;;
        8) view_log ;;
        0) echo "Goodbye!"; break ;;
        *) echo "Invalid choice. Try again." ;;
    esac
done