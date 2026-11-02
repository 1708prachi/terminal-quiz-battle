# 🎮 Terminal Quiz Battle

Terminal Quiz Battle is a terminal-based quiz game created using Bash Shell Scripting. It helps users practice Linux commands through multiple-choice questions.

## ✨ Features

- Start a quiz with 5 random questions.
- Choose answers from options A, B, C, and D.
- Calculate the final score and percentage.
- Display the time taken to complete the quiz.
- Save quiz results.
- View recent results and all scores.
- Search a player's quiz history.
- Review incorrect answers.
- View all available questions.
- Create compressed backups of project data.
- Record activities in a log file.
- Generate a Question of the Day.

## 🛠️ Technologies Used

- Bash Shell Scripting
- Linux Commands
- CSV Files
- Tar Backup Utility
- Cron Scheduler

## 📂 Project Structure

```text
quizbattle/
├── main.sh
├── README.md
├── lib/
│   └── functions.sh
├── data/
│   └── questions.csv
├── reports/
│   ├── results.csv
│   └── wrong.txt
├── logs/
│   ├── activity.log
│   └── cron.log
└── backups/
```

## 🚀 How to Run

1. Open a Linux terminal.
2. Navigate to the project directory.
3. Give execution permission to the main script:

   ```bash
   chmod +x main.sh
   ```

4. Start the application:

   ```bash
   ./main.sh
   ```

## 📋 Menu Options

| Option | Description |
|---|---|
| 1 | Start Quiz |
| 2 | View Recent Results |
| 3 | View All Scores |
| 4 | Search Player History |
| 5 | Review Wrong Answers |
| 6 | View Questions |
| 7 | Create Backup |
| 8 | View Activity Log |
| 0 | Exit |

## ⏰ Question of the Day

The project includes a Question of the Day feature. Automatic daily execution requires a Linux environment with Cron configured.

## 🎓 Project Purpose

This project demonstrates the use of Bash scripting, conditional statements, loops, functions, file handling, Linux commands, logging, and backup operations.


## Project Guide

This project was completed under the guidance of **Dr. Anjum Y. Mansuri**, Assistant Professor, Computer Applications, LJ Institute of Computer Applications, LJ University, Ahmedabad.

**GitHub:** [@anjum-mansuri](https://github.com/anjum-mansuri)

**Course:** OS Linux Lab 260120510  
**Project Title:** Terminal Quiz Battle  
**Project ID:** L16
