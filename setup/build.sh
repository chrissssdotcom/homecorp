#!/bin/bash

# Ensuring the script is run as root
if [ "$(id -u)" -ne 0 ]; then
    echo "This script must be run as root." >&2
    exit 1
fi

# Creating a folder /srv/configuration/apps
mkdir -p /srv/configuration/apps
if [ $? -ne 0 ]; then
    echo "Failed to create directory /srv/configuration/apps." >&2
    exit 1
fi

# Define the file with app names
APP_FILE="../services.txt"

# Check if the apps.txt file exists
if [ ! -f "$APP_FILE" ]; then
    echo "App list file $APP_FILE not found." >&2
    exit 1
fi

# Read the file line by line to create folders for each app
while IFS= read -r app_name; do
    mkdir -p "/srv/configuration/apps/$app_name"
    if [ $? -ne 0 ]; then
        echo "Failed to create directory for $app_name." >&2
    else
        echo "Directory created for $app_name."
    fi
done < "$APP_FILE"

# Check if Docker is installed
if ! command -v docker &> /dev/null; then
    echo "Docker is not installed. You can install Docker by visiting the following link:"
    echo "[Insert Docker installation link here]"
fi

echo "Script completed successfully."
