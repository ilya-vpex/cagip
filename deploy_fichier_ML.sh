#!/bin/bash

# Define variables
ZIP_FILE="*.zip"  # Assuming only one zip file is in the current directory
DEST_DIR="/path/to/destination"  # Change this to the correct destination path
LOG_FILE="backup_log_$(date +%Y%m%d).log"
DATE_SUFFIX="$(date +%Y%m%d)"
HOSTNAME_SUBSTRING="$(hostname | cut -d'.' -f1)"  # Extract relevant part of hostname

# Function to log messages
log_message() {
    echo "$(date +'%Y-%m-%d %H:%M:%S') - $1" | tee -a "$LOG_FILE"
}

log_message "Script started on $(hostname)"

# Find zip file
ZIP_FOUND=$(ls $ZIP_FILE 2>/dev/null)
if [ -z "$ZIP_FOUND" ]; then
    log_message "No ZIP file found. Exiting."
    exit 1
fi

log_message "Using ZIP file: $ZIP_FOUND"

# Extract files matching hostname substring
unzip -o "$ZIP_FOUND" "*$HOSTNAME_SUBSTRING*" 2>&1 | tee -a "$LOG_FILE"

# Get a list of extracted files
EXTRACTED_FILES=$(ls *$HOSTNAME_SUBSTRING* 2>/dev/null)
if [ -z "$EXTRACTED_FILES" ]; then
    log_message "No files extracted matching hostname substring. Exiting."
    exit 1
fi

log_message "Extracted files: $EXTRACTED_FILES"

# Process each extracted file
for FILE in $EXTRACTED_FILES; do
    if [ -f "$FILE" ]; then
        BACKUP_FILE="$DEST_DIR/${FILE}_$DATE_SUFFIX"
        
        # Check if backup already exists
        if [ ! -e "$BACKUP_FILE" ]; then
            cp "$FILE" "$BACKUP_FILE"
            log_message "Backup created: $BACKUP_FILE"
        else
            log_message "Backup already exists, skipping: $BACKUP_FILE"
        fi
        
        # Copy extracted file to destination directory
        cp "$FILE" "$DEST_DIR/"
        chmod 750 "$DEST_DIR/$FILE"
        log_message "Copied and changed permissions: $DEST_DIR/$FILE"
    fi
done

log_message "Script completed."
