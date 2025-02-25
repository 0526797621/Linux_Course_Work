#!/bin/bash

OUTPUT_FILE="5_output.txt"
LAST_CSV_FILE=""

# Function to log output both to console and to the output file
log_output() {
    echo "$1" | tee -a "$OUTPUT_FILE"
}

# Function to check if a CSV file has been created
check_csv_exists() {
    if [ -z "$LAST_CSV_FILE" ] || [ ! -f "$LAST_CSV_FILE" ]; then
        log_output "Error: No CSV file has been created yet. Please create a CSV file using option 1."
        return 1
    fi
    return 0
}

# Function to create a new CSV file by name
create_csv() {
    read -p "Enter the CSV file name: " filename
    echo "Date collected,Species,Sex,Weight" > "$filename"
    LAST_CSV_FILE="$filename"
    log_output "Created CSV file: $filename with headers"
}

# Function to display all CSV data with row index (excluding header)
display_all_csv() {
    if check_csv_exists; then
        log_output "Displaying all CSV data with row index from $LAST_CSV_FILE:"
        awk 'NR==1 {print $0; next} {print NR-1 ") " $0}' "$LAST_CSV_FILE" | tee -a "$OUTPUT_FILE"
        log_output "Displayed all data with row index"
    fi
}

# Function to add a new row to the CSV file
add_row() {
    if check_csv_exists; then
        read -p "Enter date collected (e.g. 1/8): " date
        read -p "Enter species (e.g. PF): " species
        read -p "Enter sex (M/F): " sex
        read -p "Enter weight: " weight
        echo "$date,$species,$sex,$weight" >> "$LAST_CSV_FILE"
        log_output "Added new row: $date,$species,$sex,$weight to $LAST_CSV_FILE"
    fi
}

# Function to display all items of a specific species and calculate the average weight
display_specie_avg() {
    if check_csv_exists; then
        read -p "Enter species to search (e.g. OT): " species
        log_output "Items of species '$species' in $LAST_CSV_FILE:"
        awk -F',' 'NR>1 && $2 == sp {print $0}' sp="$species" "$LAST_CSV_FILE" | tee -a "$OUTPUT_FILE"
        avg_weight=$(awk -F',' 'NR>1 && $2 == sp {sum+=$4; count++} END {if (count > 0) print sum/count}' sp="$species" "$LAST_CSV_FILE")
        echo "Average weight for $species: $avg_weight" | tee -a "$OUTPUT_FILE"
        log_output "Displayed all items of species '$species' and average weight: $avg_weight"
    fi
}

# Function to display all items of a specific species and sex, and calculate the average weight
display_specie_sex() {
    if check_csv_exists; then
        read -p "Enter species (e.g. OT): " species
        read -p "Enter sex (M/F): " sex
        log_output "Items of species '$species' and sex '$sex' in $LAST_CSV_FILE:"
        awk -F',' 'NR>1 && $2 == sp && $3 == sx {print $0}' sp="$species" sx="$sex" "$LAST_CSV_FILE" | tee -a "$OUTPUT_FILE"
        avg_weight=$(awk -F',' 'NR>1 && $2 == sp && $3 == sx {sum+=$4; count++} END {if (count > 0) print sum/count}' sp="$species" sx="$sex" "$LAST_CSV_FILE")
        echo "Average weight for $species and sex $sex: $avg_weight" | tee -a "$OUTPUT_FILE"
        log_output "Displayed all items of species '$species' and sex '$sex' and average weight: $avg_weight"
    fi
}

# Function to save the last output to a new CSV file (unchanged)
save_output_to_csv() {
    if check_csv_exists; then
        read -p "Enter the filename to save the output: " new_file
        cp "$LAST_CSV_FILE" "$new_file"
        log_output "Saved last output to new CSV file: $new_file"
    fi
}

# Function to delete a row by its index (adjusted for header)
delete_row() {
    if check_csv_exists; then
        read -p "Enter the row index to delete: " row_index
        actual_row=$((row_index + 1))
        sed -i "${actual_row}d" "$LAST_CSV_FILE"
        log_output "Deleted row with index: $row_index from $LAST_CSV_FILE"
    fi
}

# Function to update the weight of a row by its index (adjusted for header)
update_weight() {
    if check_csv_exists; then
        read -p "Enter the row index to update: " row_index
        read -p "Enter the new weight: " new_weight
        actual_row=$((row_index + 1))
        sed -i "${actual_row}s/\([^,]*,[^,]*,[^,]*,\)[0-9]*/\1$new_weight/" "$LAST_CSV_FILE"
        log_output "Updated weight for row with index: $row_index to $new_weight in $LAST_CSV_FILE"
    fi
}

# Menu function to display options and handle user input
menu() {
    while true; do
        echo "Choose an option:"
        echo "1. CREATE CSV by name"
        echo "2. Display all CSV DATA with row INDEX"
        echo "3. Read user input for new row"
        echo "4. Read Species (e.g. OT) and display all items of that species and the AVG weight"
        echo "5. Read Species and Sex (M/F) and display all items of species-sex"
        echo "6. Save last output to new CSV file"
        echo "7. Delete row by row index"
        echo "8. Update weight by row index"
        echo "9. Exit"
        read -p "Select an option: " choice

        case $choice in
            1) create_csv ;;
            2) display_all_csv ;;
            3) add_row ;;
            4) display_specie_avg ;;
            5) display_specie_sex ;;
            6) save_output_to_csv ;;
            7) delete_row ;;
            8) update_weight ;;
            9) log_output "Exiting program"; exit 0 ;;
            *) log_output "Invalid option. Please try again." ;;
        esac
    done
}

# Start the menu
menu
