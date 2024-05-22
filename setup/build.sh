#!/bin/bash

# Check if the script is running as root
if [ "$(id -u)" -ne 0 ]; then
    echo "This script must be run as root. Please run with sudo."
    exit 1
fi

# Install yq if not already installed
if ! command -v yq &> /dev/null; then
    echo "yq not found. Installing yq..."
    sudo apt-get update
    sudo apt-get install -y yq
    if [ $? -ne 0 ]; then
        echo "Failed to install yq. Please install it manually."
        exit 1
    fi
fi

# Define the target directory
TARGET_DIR="/srv/configuration/apps"

# Create the target directory if it doesn't exist
if [ ! -d "$TARGET_DIR" ]; then
    mkdir -p "$TARGET_DIR"
    echo "Created directory $TARGET_DIR"
else
    echo "Directory $TARGET_DIR already exists"
fi

# Define the apps list file
APPS_FILE="../apps.yaml"

# Check if the apps list file exists
if [ ! -f "$APPS_FILE" ]; then
    echo "File $APPS_FILE not found. Please create the file with a list of apps."
    exit 1
fi

# Read the YAML file and create directories for each app
apps=$(yq eval '.apps[].name' "$APPS_FILE")
for app_name in $apps; do
    app_dir="$TARGET_DIR/$app_name"
    if [ ! -d "$app_dir" ]; then
        mkdir "$app_dir"
        echo "Created directory $app_dir"
    else
        echo "Directory $app_dir already exists"
    fi
done

# Check if Docker is installed
if ! command -v docker &> /dev/null; then
    echo "Docker is not installed. Please install Docker from the official website: https://docs.docker.com/get-docker/"
else
    echo "Docker is already installed."
fi
