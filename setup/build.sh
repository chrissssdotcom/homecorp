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

# Define the target directories
CONFIG_DIR="/srv/configuration/apps"
CONTAINER_DATA_DIR="/mnt/container-data"

# Create the target directories if they don't exist
if [ ! -d "$CONFIG_DIR" ]; then
    mkdir -p "$CONFIG_DIR"
    echo "Created directory $CONFIG_DIR"
else
    echo "Directory $CONFIG_DIR already exists"
fi

if [ ! -d "$CONTAINER_DATA_DIR" ]; then
    mkdir -p "$CONTAINER_DATA_DIR"
    echo "Created directory $CONTAINER_DATA_DIR"
else
    echo "Directory $CONTAINER_DATA_DIR already exists"
fi

# Define the apps list file
APPS_FILE="apps.yaml"

# Check if the apps list file exists
if [ ! -f "$APPS_FILE" ]; then
    echo "File $APPS_FILE not found. Please create the file with a list of apps."
    exit 1
fi

# Read the YAML file and create directories for each app
apps=$(yq eval '.apps[].name' "$APPS_FILE")
for app_name in $apps; do
    config_app_dir="$CONFIG_DIR/$app_name"
    container_app_dir="$CONTAINER_DATA_DIR/$app_name"
    
    # Create the configuration directory for the app
    if [ ! -d "$config_app_dir" ]; then
        mkdir "$config_app_dir"
        echo "Created directory $config_app_dir"
    else
        echo "Directory $config_app_dir already exists"
    fi

    # Create the container data directory for the app
    if [ ! -d "$container_app_dir" ]; then
        mkdir "$container_app_dir"
        echo "Created directory $container_app_dir"
    else
        echo "Directory $container_app_dir already exists"
    fi
done

# Check if Docker is installed
if ! command -v docker &> /dev/null; then
    echo "Docker is not installed. Please install Docker from the official website: https://docs.docker.com/get-docker/"
else
    echo "Docker is already installed."
fi
