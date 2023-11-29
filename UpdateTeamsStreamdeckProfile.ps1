# Define the name of your Teams profile in Stream Deck
$StreamDeckTeamsProfileName = "Teams Profile"

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

            # Initialize a variable for the user's response
            $response = $null
            if ($content.AppIdentifier -eq $NewTeamsEXEPath){                
                # Start a while loop that continues until the user enters 'y' or 'n'
                while ($response -ne 'y' -and $response -ne 'n') {
                    # Ask the user for input
                    $response = Read-Host "The AppIdentifiers are the same, no update required. Force anyway? (y/n)"

                    # Check the user's response
                    if ($response -eq 'n') {
                        # Exit the script
                        exit
                    }
                }
            }

            # Initialize a variable for the user's response
            $response = $null

            # Start a while loop that continues until the user enters 'y' or 'n'
            while ($response -ne 'y' -and $response -ne 'n') {
                # Ask the user for input
                $response = Read-Host "We need to close Teams client and StremDeck app. Do you want to continue? (y/n)"

                # Check the user's response
                if ($response -eq 'y') {
                    
                    # Get EXE path and Close Teams client & StremDeck app
                    $streamDeckPath = (Get-Process StreamDeck -ErrorAction SilentlyContinue).Path
                    if (!$streamDeckPath){
                        $streamDeckPath = "$env:ProgramFiles\Elgato\StreamDeck\StreamDeck.exe"
                    }
                    Stop-Process -Name ms-teams -Force -ErrorAction SilentlyContinue
                    Stop-Process -Name StreamDeck -Force -ErrorAction SilentlyContinue

                    # Update the AppIdentifier
                    $content.AppIdentifier = $NewTeamsEXEPath

                    # Convert the modified object back to a JSON string
                    $json = $content | ConvertTo-Json -Depth 20

                    # Write the JSON string back to the file
                    Set-Content -Path $file.FullName -Value $json

                    # Start Teams client and StremDeck app
                    
                    Start-Process -FilePath $NewTeamsEXEPath -ErrorAction SilentlyContinue
                    Start-Process -FilePath $streamDeckPath -ErrorAction SilentlyContinue            
                }
            }
        }
    }
    if (!$found){
        Write-Host "No matching profile found." -ForegroundColor Yellow    
    }
} else {
    Write-Output "The path $path does not exist."
}