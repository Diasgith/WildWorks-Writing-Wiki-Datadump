#!/bin/bash

# Input file
inputfile="inputfile.txt"

# Get the total number of lines in the file
total_lines=$(wc -l < "$inputfile")

# Calculate the number of lines per part
lines_per_part=$(( (total_lines + 3) / 4 ))

# Split the file into 4 parts
split -l "$lines_per_part" "$inputfile" part_

# Rename the parts accordingly
mv part_aa part_1.txt
mv part_ab part_2.txt
mv part_ac part_3.txt
mv part_ad part_4.txt

