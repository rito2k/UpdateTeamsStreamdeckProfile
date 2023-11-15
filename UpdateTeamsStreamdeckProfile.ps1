# Define the name of your Teams profile in Stream Deck
$StreamDeckTeamsProfileName = "Teams Profil"
#$StreamDeckTeamsProfileName = '"Name": "'+$StreamDeckTeamsProfileName+'",'
# Define the path to ElGato StreamDeck profiles folder
$path = "$env:USERPROFILE\AppData\Roaming\Elgato\StreamDeck\ProfilesV2"
Write-Host "Search path: " -NoNewline -ForegroundColor Cyan
Write-Host $path
# Check if the path exists
if (Test-Path $path) {
    # Get the current (updated) Teams client path
    $TeamsPath = (Get-AppxPackage MSTeams).InstallLocation
    Write-Host "Teams install location: " -NoNewline -ForegroundColor Cyan
    Write-Host $TeamsPath
    # Define full path to Teams client EXE file
    $NewTeamsEXEPath = $TeamsPath + "\ms-teams.exe"
    Write-Host "New Teams client EXE path: " -NoNewline -ForegroundColor Cyan
    Write-Host $NewTeamsEXEPath
    
    # Get all the manifest.json files in the child folders
    $files = Get-ChildItem -Path $path -Filter manifest.json -Recurse -File

    $found = $false
    # Loop through each file
    foreach ($file in $files) {
        # Read the file content and convert it to a PowerShell object
        $content = Get-Content -Path $file.FullName -Raw | ConvertFrom-Json

        # Check if the Name property matches your defined Teams profile name
        if ($content.Name -eq $StreamDeckTeamsProfileName) {
            $found = $true

            Write-Host "Profile JSON file found: " -NoNewline -ForegroundColor Green
            Write-Host $file.FullName
            
            # Output the old AppIdentifier
            Write-Host "OLD AppIdentifier: " -NoNewline -ForegroundColor Cyan
            Write-Host $content.AppIdentifier

            # Output the new AppIdentifier
            Write-Host "NEW AppIdentifier: " -NoNewline -ForegroundColor Cyan
            Write-Host $NewTeamsEXEPath

            <#
            # UNCOMMENT THIS SECTION to indeed update the AppIdentifier
            $content.AppIdentifier = $NewTeamsEXEPath

            # Convert the modified object back to a JSON string
            $json = $content | ConvertTo-Json -Depth 20

            # Write the JSON string back to the file
            Set-Content -Path $file.FullName -Value $json
            #>
        }
    }
    if (!$found){
        Write-Host "No matching profile found." -ForegroundColor Yellow    
    }
} else {
    Write-Output "The path $path does not exist."
}