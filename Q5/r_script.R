#!/usr/bin/env Rscript

output_file <- "/app/5_R_outputs.txt" # שינוי הנתיב
write("R Script Output Log", file = output_file)

data <- read.csv("input.csv", header = TRUE)

log_output <- function(message) {
  cat(message, "\n")
  write(message, file = output_file, append = TRUE)
}

group_by_species_mean <- function() {
  library(dplyr)
  result <- data %>% 
    group_by(Species) %>% 
    summarise(Mean_Weight = mean(Weight, na.rm = TRUE))
  log_output("Group by Species and Calculate Mean Weight:")
  log_output(capture.output(print(result)))
}

total_weight_by_species <- function() {
  library(dplyr)
  result <- data %>% 
    group_by(Species) %>% 
    summarise(Total_Weight = sum(Weight, na.rm = TRUE))
  log_output("Calculate the Total Weight by Species:")
  log_output(capture.output(print(result)))
}

sort_by_weight <- function() {
  sorted_data <- data[order(data$Weight), ]
  log_output("Sorting the Data by Weight:")
  log_output(capture.output(print(sorted_data)))
}

count_records_per_species <- function() {
  library(dplyr)
  result <- data %>% 
    group_by(Species) %>% 
    summarise(Count = n())
  log_output("Count the Number of Records per Species:")
  log_output(capture.output(print(result)))
}

menu <- function() {
  while (TRUE) {
    cat("\nChoose an option:\n")
    cat("1. Group by Species and Calculate Mean Weight\n")
    cat("2. Calculate the Total Weight by Species\n")
    cat("3. Sort the Data by Weight\n")
    cat("4. Count the Number of Records per Species\n")
    cat("5. Exit\n")
    cat("Select an option: ")
    flush.console() # מבטיח שהטקסט מופיע במסוף
    choice <- as.integer(readLines(con = "stdin", n = 1))
    
    if (length(choice) == 0 || is.na(choice)) {
      log_output("Invalid option. Please try again.")
      next
    }
    
    if (choice == 1) group_by_species_mean()
    else if (choice == 2) total_weight_by_species()
    else if (choice == 3) sort_by_weight()
    else if (choice == 4) count_records_per_species()
    else if (choice == 5) {
      log_output("Exiting program")
      break
    } else {
      log_output("Invalid option. Please try again.")
    }
  }
}

menu()
