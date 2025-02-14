# Create the "unzipped" directory if it doesn't exist
New-Item -ItemType Directory -Path "unzipped" -Force

# Unzip all .zip files into the "unzipped" directory
Get-ChildItem -Path . -Filter *.zip | ForEach-Object {
    $zipFile = $_.FullName
    $baseName = [System.IO.Path]::GetFileNameWithoutExtension($zipFile)
    $unzipDir = Join-Path -Path "unzipped" -ChildPath $baseName

    # Create a directory for the unzipped contents
    New-Item -ItemType Directory -Path $unzipDir -Force

    # Unzip the file into the corresponding directory
    Expand-Archive -Path $zipFile -DestinationPath $unzipDir
}

# Create the "rezipped" directory if it doesn't exist
New-Item -ItemType Directory -Path "rezipped" -Force

# Re-zip each of the unzipped folders into the "rezipped" directory
Get-ChildItem -Path "unzipped" -Directory | ForEach-Object {
    $unzippedDir = $_.FullName
    $baseName = $_.Name
    $zipFilePath = Join-Path -Path "rezipped" -ChildPath "$baseName.zip"

    # Zip the contents of the unzipped directory
    Compress-Archive -Path "$unzippedDir\*" -DestinationPath $zipFilePath
}

Write-Host "Unzipping and re-zipping completed!"
