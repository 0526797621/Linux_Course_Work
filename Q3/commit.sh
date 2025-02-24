#!/bin/bash

# Path to the CSV file
CSV_FILE="bugs.csv"

# Check if the CSV file exists in the same directory as the script
if [[ ! -f "$CSV_FILE" ]]; then
  echo "Error: CSV file $CSV_FILE not found."
  exit 1
fi

# Get the current branch name
BRANCH=$(git branch --show-current)

# Search for the current branch in the CSV file and extract the necessary details
DATA=$(awk -F, -v branch="$BRANCH" '$3 == branch {print $0}' $CSV_FILE)

# If no matching branch is found, exit the script
if [[ -z "$DATA" ]]; then
  echo "Error: No data found for the current branch $BRANCH in the CSV file."
  exit 1
fi

# Extracting details from the CSV (assumes CSV format: BugID, Description, Branch, Developer, Priority, repoPath, githuburl)

BUGID=$(echo "$DATA" | cut -d',' -f1)
DESCRIPTION=$(echo "$DATA" | cut -d',' -f2)
PRIORITY=$(echo "$DATA" | cut -d',' -f5)
DEVELOPER=$(echo "$DATA" | cut -d',' -f4)
REPOPATH=$(echo "$DATA" | cut -d',' -f6)
GITHUBURL=$(echo "$DATA" | cut -d',' -f7)


# Get current date and time
CURRENT_TIME=$(date '+%Y-%m-%d %H:%M:%S')

# Build the commit message
COMMIT_MESSAGE="$BUGID:$CURRENT_TIME:$BRANCH:$DEVELOPER:$PRIORITY:$DESCRIPTION"

# Check for an optional additional developer description passed as an argument
if [[ ! -z "$1" ]]; then
  COMMIT_MESSAGE="$COMMIT_MESSAGE:$1"
fi

# Stage the changes
git add .

# Commit the changes
git commit -m "$COMMIT_MESSAGE"

# Push to GitHub
git push origin "$BRANCH"

# Check if the commit and push were successful
if [[ $? -eq 0 ]]; then
  echo "Commit and push were successful."
else
  echo "Error: Commit or push failed."
  exit 1
fi

