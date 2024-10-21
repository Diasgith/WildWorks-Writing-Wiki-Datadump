#!/bin/bash

# Input file
inputfile="inputfile.txt"

# Temporary file to hold the filtered content
tempfile=$(mktemp)

# Read through the file and process segments
awk '
    BEGIN { RS="</page>"; FS="\n" } 
    {
        # Extract the page content
        page_content = $0

        # Extract the title from the page
        title = ""
        match(page_content, /<title>.*<\/title>/, arr_title)
        if (arr_title[0] != "") {
            title = arr_title[0]
            gsub(/<\/?title>/, "", title) # Remove <title> tags
        }

        # Extract the username from the page
        username = ""
        match(page_content, /<username>.*<\/username>/, arr_username)
        if (arr_username[0] != "") {
            username = arr_username[0]
            gsub(/<\/?username>/, "", username) # Remove <username> tags
        }

        # Convert title and username to lowercase for case-insensitive checks
        title_lower = tolower(title)
        username_lower = tolower(username)

        # Conditions for deletion:
        delete_segment = 0

        # Check if title contains any of the unwanted terms
        if (title_lower ~ /(png|jpg|jpeg|webp|mov|pdf)/) {
            delete_segment = 1
        }

        # Check if username contains FANDOMbot
        if (username_lower ~ /fandombot/) {
            delete_segment = 1
        }

        # If the segment should not be deleted, write it to the tempfile
        if (delete_segment == 0) {
            print $0 "</page>" >> "'"$tempfile"'"
        }
    }
' "$inputfile"

# Replace the original input file with the filtered content
mv "$tempfile" "$inputfile"

# Cleanup
rm -f "$tempfile"

