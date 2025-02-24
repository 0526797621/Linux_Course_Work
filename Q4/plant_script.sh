#!/bin/bash

# הגדרת משתנים
REPO_PATH=~/Linux_Course_Work/Q4
VENV_PATH=~/my_venv
CSV_FILE=$1  # המסלול לקובץ CSV (הפרמטר הראשון שהועבר לסקריפט)
LOG_FILE=~/plant_processing.log

# Function to log messages
log() {
  echo "$(date) - $1" >> $LOG_FILE
}

# Checking if the virtual environment exists
if [ ! -d "$VENV_PATH" ]; then
  log "Creating virtual environment at $VENV_PATH"
  python3 -m venv "$VENV_PATH"
  if [ $? -ne 0 ]; then
    log "Error: Failed to create virtual environment."
    exit 1
  fi
else
  log "Virtual environment already exists at $VENV_PATH"
fi

# Activating the virtual environment
source "$VENV_PATH/bin/activate"

# Checking if requirements.txt exists, if not, creating it
REQUIREMENTS_FILE="$REPO_PATH/requirements.txt"
if [ ! -f "$REQUIREMENTS_FILE" ]; then
  log "requirements.txt not found. Creating the file."
  echo "matplotlib" > "$REQUIREMENTS_FILE"  # הוספת ספריה לדוגמה (הוסף ספריות נוספות לפי הצורך)
  echo "numpy" >> "$REQUIREMENTS_FILE"
  echo "pandas" >> "$REQUIREMENTS_FILE"
  log "Created requirements.txt"
fi

# Installing dependencies if not already installed
log "Installing dependencies"
pip install --trusted-host pypi.org --trusted-host pypi.python.org --trusted-host=files.pythonhosted.org -r "$REQUIREMENTS_FILE"
if [ $? -ne 0 ]; then
  log "Error: Failed to install dependencies."
  deactivate
  exit 1
fi

# Reading the CSV file and processing each row
log "Processing CSV file: $CSV_FILE"
while IFS=, read -r plant height leaf_count dry_weight; do
  # Skipping the header row
  if [ "$plant" == "Plant" ]; then
    continue
  fi

  log "Processing plant: $plant"

  # Creating a directory for the plant if it does not exist
  PLANT_DIR="$REPO_PATH/$plant"
  if [ ! -d "$PLANT_DIR" ]; then
    mkdir "$PLANT_DIR"
    log "Created directory: $PLANT_DIR"
  fi

 # Running the Python script for the plant
height_array=($(echo "$height" | tr -d '"'))
leaf_count_array=($(echo "$leaf_count" | tr -d '"'))
dry_weight_array=($(echo "$dry_weight" | tr -d '"'))

  python3 "$REPO_PATH/plant_plots.py" --plant "$plant" --height "${height_array[@]}" --leaf_count "${leaf_count_array[@]}" --dry_weight "${dry_weight_array[@]}"
  if [ $? -ne 0 ]; then
    log "Error: Python script failed for plant $plant with parameters height=$height, leaf_count=$leaf_count, dry_weight=$dry_weight"
    continue
  fi

  # Moving the generated plots to the appropriate directory
  mv "$REPO_PATH/${plant}_scatter.png" "$PLANT_DIR/"
  mv "$REPO_PATH/${plant}_histogram.png" "$PLANT_DIR/"
  mv "$REPO_PATH/${plant}_line_plot.png" "$PLANT_DIR/"
  log "Moved plot files for $plant to $PLANT_DIR"

done < "$CSV_FILE"

log "All plants processed successfully."
deactivate

