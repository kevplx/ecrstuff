# Create the "unzipped" directory if it doesn't exist
New-Item -ItemType Directory -Path "unzipped" -Force

# Create the "rezipped" directory if it doesn't exist
New-Item -ItemType Directory -Path "rezipped" -Force

# Unzip all .zip files into the "unzipped" directory
Get-ChildItem -Path . -Filter *.zip | ForEach-Object {
    $zipFile = $_.FullName
    $baseName = [System.IO.Path]::GetFileNameWithoutExtension($zipFile)
    $unzipDir = Join-Path -Path "unzipped" -ChildPath $baseName

    # Create a directory for the unzipped contents
    New-Item -ItemType Directory -Path $unzipDir -Force

    # Unzip the file into the corresponding directory
    Expand-Archive -Path $zipFile -DestinationPath $unzipDir

    # Iterate through each .p12 file in the unzipped directory
    Get-ChildItem -Path $unzipDir -Filter *.p12 | ForEach-Object {
        $p12File = $_.FullName
        $p12FileName = $_.Name

        # Create a zip file for each .p12 file in the "rezipped" folder
        $zipFilePath = Join-Path -Path "rezipped" -ChildPath "$p12FileName.zip"
        Compress-Archive -Path $p12File -DestinationPath $zipFilePath
    }
}

Write-Host "Unzipping and re-zipping completed!"
