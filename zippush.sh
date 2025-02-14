#!/bin/bash

# Variables
GITLAB_URL="https://gitlab.com"  # Change if using self-hosted GitLab
PROJECT_ID="123456"              # Replace with your project ID
ACCESS_TOKEN="your_access_token" # Replace with your access token
FILES_DIR="/path/to/your/files"  # Replace with the path to your files

# Loop through all files in the directory
for file in "$FILES_DIR"/*; do
    echo "Uploading $file..."

    # Upload the file using the GitLab API
    curl --request POST \
         --header "PRIVATE-TOKEN: $ACCESS_TOKEN" \
         --form "file=@$file" \
         "$GITLAB_URL/api/v4/projects/$PROJECT_ID/secure_files"

    echo "Uploaded $file."
done

echo "All files uploaded!"
