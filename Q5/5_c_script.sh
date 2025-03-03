#!/bin/bash

OUTPUT_FILE="5_c_output.txt"
DB_FILE=""

# Function to log output both to console and to the output file
log_output() {
    echo "$1" | tee -a "$OUTPUT_FILE"
}

# Function to check if the database and table exist
check_db_exists() {
    if [ ! -f "$DB_FILE" ]; then
        log_output "Error: Database does not exist. Please create the database first."
        return 1
    fi
    return 0
}

# Function to create the database and the data table
create_db() {
    read -p "Enter the name of the database file (e.g. animals.db): " db_name
    DB_FILE="$db_name"
    
    sqlite3 "$DB_FILE" "CREATE TABLE IF NOT EXISTS data (id INTEGER PRIMARY KEY AUTOINCREMENT, DateCollected TEXT, Species TEXT, Sex TEXT, Weight REAL);"
    log_output "Created database '$DB_FILE' and table 'data'."
}

# Function to display all data with row index (excluding header)
display_all_db() {
    if check_db_exists; then
        log_output "Displaying all data with row index from the database:"
        sqlite3 "$DB_FILE" "SELECT rowid, DateCollected, Species, Sex, Weight FROM data;" | tee -a "$OUTPUT_FILE"
        log_output "Displayed all data with row index."
    fi
}

# Function to add a new row to the database
add_row() {
    if check_db_exists; then
        read -p "Enter date collected (e.g. 1/8): " date
        read -p "Enter species (e.g. PF): " species
        read -p "Enter sex (M/F): " sex
        read -p "Enter weight: " weight
        sqlite3 "$DB_FILE" "INSERT INTO data (DateCollected, Species, Sex, Weight) VALUES ('$date', '$species', '$sex', $weight);"
        log_output "Added new row: $date, $species, $sex, $weight to the database."
    fi
}

# Function to display all items of a specific species and calculate the average weight
display_specie_avg() {
    if check_db_exists; then
        read -p "Enter species to search (e.g. OT): " species
        log_output "Items of species '$species' in the database:"
        sqlite3 "$DB_FILE" "SELECT * FROM data WHERE Species = '$species';" | tee -a "$OUTPUT_FILE"
        avg_weight=$(sqlite3 "$DB_FILE" "SELECT AVG(Weight) FROM data WHERE Species = '$species';")
        echo "Average weight for $species: $avg_weight" | tee -a "$OUTPUT_FILE"
        log_output "Displayed all items of species '$species' and average weight: $avg_weight"
    fi
}

# Function to display all items of a specific species and sex, and calculate the average weight
display_specie_sex() {
    if check_db_exists; then
        read -p "Enter species (e.g. OT): " species
        read -p "Enter sex (M/F): " sex
        log_output "Items of species '$species' and sex '$sex' in the database:"
        sqlite3 "$DB_FILE" "SELECT * FROM data WHERE Species = '$species' AND Sex = '$sex';" | tee -a "$OUTPUT_FILE"
        avg_weight=$(sqlite3 "$DB_FILE" "SELECT AVG(Weight) FROM data WHERE Species = '$species' AND Sex = '$sex';")
        echo "Average weight for $species and sex $sex: $avg_weight" | tee -a "$OUTPUT_FILE"
        log_output "Displayed all items of species '$species' and sex '$sex' and average weight: $avg_weight"
    fi
}

# Function to save the last output to a new database
save_output_to_db() {
    if check_db_exists; then
        read -p "Enter the filename to save the output: " new_db
        cp "$DB_FILE" "$new_db"
        log_output "Saved last output to new database: $new_db"
    fi
}

# Function to delete a row by its index (adjusted for database)
delete_row() {
    if check_db_exists; then
        read -p "Enter the row index to delete: " row_index
        sqlite3 "$DB_FILE" "DELETE FROM data WHERE rowid = $row_index;"
        log_output "Deleted row with index: $row_index from the database."
    fi
}

# Function to update the weight of a row by its index (adjusted for database)
update_weight() {
    if check_db_exists; then
        read -p "Enter the row index to update: " row_index
        read -p "Enter the new weight: " new_weight
        sqlite3 "$DB_FILE" "UPDATE data SET Weight = $new_weight WHERE rowid = $row_index;"
        log_output "Updated weight for row with index: $row_index to $new_weight in the database."
    fi
}

# Menu function to display options and handle user input
menu() {
    while true; do
        echo "Choose an option:"
        echo "1. CREATE database and table"
        echo "2. Display all data with row index"
        echo "3. Read user input for new row"
        echo "4. Read Species (e.g. OT) and display all items of that species and the AVG weight"
        echo "5. Read Species and Sex (M/F) and display all items of species-sex"
        echo "6. Save last output to new database"
        echo "7. Delete row by row index"
        echo "8. Update weight by row index"
        echo "9. Exit"
        read -p "Select an option: " choice

        case $choice in
            1) create_db ;;
            2) display_all_db ;;
            3) add_row ;;
            4) display_specie_avg ;;
            5) display_specie_sex ;;
            6) save_output_to_db ;;
            7) delete_row ;;
            8) update_weight ;;
            9) log_output "Exiting program"; exit 0 ;;
            *) log_output "Invalid option. Please try again." ;;
        esac
    done
}

# Start the menu
menu
