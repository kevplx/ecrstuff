#!/bin/bash

# Create the "unzipped" directory if it doesn't exist
mkdir -p unzipped

# Unzip all .zip files into the "unzipped" directory
for zipfile in *.zip; do
    # Extract the base name of the zip file (without the .zip extension)
    base_name=$(basename "$zipfile" .zip)
    
    # Create a directory for the unzipped contents
    unzip_dir="unzipped/$base_name"
    mkdir -p "$unzip_dir"
    
    # Unzip the file into the corresponding directory
    unzip -q "$zipfile" -d "$unzip_dir"
done

# Create the "rezipped" directory if it doesn't exist
mkdir -p rezipped

# Re-zip each of the unzipped folders into the "rezipped" directory
for unzipped_dir in unzipped/*; do
    # Get the base name of the unzipped directory
    base_name=$(basename "$unzipped_dir")
    
    # Zip the contents of the unzipped directory
    zip -r "rezipped/$base_name.zip" "$unzipped_dir" > /dev/null
done

echo "Unzipping and re-zipping completed!"
