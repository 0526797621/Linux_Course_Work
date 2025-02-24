#!/bin/bash

CSV_FILE="data.csv"
OUTPUT_FILE="5_output.txt"

# Function to log output both to console and to the output file
log_output() {
    echo "$1" | tee -a $OUTPUT_FILE
}

# Function to create a new CSV file by name
create_csv() {
    read -p "Enter the CSV file name: " filename
    touch "$filename"
    log_output "Created CSV file: $filename"
}

# Function to display all CSV data with row index
display_all_csv() {
    log_output "Displaying all CSV data with row index:"
    awk '{print NR, $0}' $CSV_FILE | tee -a $OUTPUT_FILE
    log_output "Displayed all data with row index"
}

# Function to add a new row to the CSV file
add_row() {
    read -p "Enter date collected (e.g. 1/8): " date
    read -p "Enter species (e.g. PF): " species
    read -p "Enter sex (M/F): " sex
    read -p "Enter weight: " weight
    echo "$date,$species,$sex,$weight" >> $CSV_FILE
    log_output "Added new row: $date,$species,$sex,$weight"
}

# Function to display all items of a specific species and calculate the average weight of that species
display_specie_avg() {
    read -p "Enter species to search (e.g. OT): " species
    log_output "Items of species '$species':"
    awk -F',' -v sp="$species" '$2 == sp {print $0}' $CSV_FILE | tee -a $OUTPUT_FILE
    avg_weight=$(awk -F',' -v sp="$species" '$2 == sp {sum+=$4; count++} END {if (count > 0) print sum/count}' $CSV_FILE)
    echo "Average weight for $species: $avg_weight" | tee -a $OUTPUT_FILE
    log_output "Displayed all items of species '$species' and average weight: $avg_weight"
}

# Function to display all items of a specific species and sex, and calculate the average weight of that combination
display_specie_sex() {
    read -p "Enter species (e.g. OT): " species
    read -p "Enter sex (M/F): " sex
    log_output "Items of species '$species' and sex '$sex':"
    awk -F',' -v sp="$species" -v sx="$sex" '$2 == sp && $3 == sx {print $0}' $CSV_FILE | tee -a $OUTPUT_FILE
    avg_weight=$(awk -F',' -v sp="$species" -v sx="$sex" '$2 == sp && $3 == sx {sum+=$4; count++} END {if (count > 0) print sum/count}' $CSV_FILE)
    echo "Average weight for $species and sex $sex: $avg_weight" | tee -a $OUTPUT_FILE
    log_output "Displayed all items of species '$species' and sex '$sex' and average weight: $avg_weight"
}

# Function to save the last output to a new CSV file
save_output_to_csv() {
    read -p "Enter the filename to save the output: " new_file
    cp $CSV_FILE $new_file
    log_output "Saved last output to new CSV file: $new_file"
}

# Function to delete a row by its index
delete_row() {
    read -p "Enter the row index to delete: " row_index
    sed -i "${row_index}d" $CSV_FILE
    log_output "Deleted row with index: $row_index"
}

# Function to update the weight of a row by its index
update_weight() {
    read -p "Enter the row index to update: " row_index
    read -p "Enter the new weight: " new_weight
    sed -i "${row_index}s/\([0-9]*,[^,]*,[^,]*,\)[0-9]*/\1$new_weight/" $CSV_FILE
    log_output "Updated weight for row with index: $row_index to $new_weight"
}

# Menu function to display options and handle user input
menu() {
    while true; do
        echo "Choose an option:"
        echo "1. CREATE CSV by name"
        echo "2. Display all CSV DATA with row INDEX"
        echo "3. Read user input for new row"
        echo "4. Read Specie (OT for example) And Display all Items of that specie type and the AVG weight of that type"
        echo "5. Read Specie sex (M/F) and display all items of specie-sex"
        echo "6. Save last output to new csv file"
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

