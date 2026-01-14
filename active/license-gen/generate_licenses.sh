#!/bin/bash

# Output CSV file
output_file="licenses_2026.csv"

# Clear the output file and add CSV header
echo "date,license_key" > "$output_file"

# Array of months (01-12)
months=("01" "02" "03" "04" "05" "06" "07" "08" "09" "10" "11" "12")

# Loop through each month of 2026
for month in "${months[@]}"
do
    date="2026-${month}-01"
    
    # Generate 15 licenses for this month
    for i in {1..15}
    do
        # Run the command and capture the output
        license_key=$(./stackstate-license -createlicense "$date")
        
        # Append to CSV
        echo "${date},${license_key}" >> "$output_file"
        
        echo "License $i for $date created"
    done
done

echo ""
echo "Done! Generated 180 licenses (15 per month x 12 months)"
echo "Output saved to: $output_file"
