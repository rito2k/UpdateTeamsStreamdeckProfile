# UpdateTeamsStreamdeckProfile.ps1
This script is intended to help re-connecting your existing profile dedicated to Microsoft Teams (work or school) related actions in the Elgato Streamdeck2 application for Microsoft Windows.

Every new Microsoft Teams client update gets installed into a changing location path related to the version number and platform.
Since the Streamdeck profile is normally connected to the executable file and its full location path, Streamdeck may loose that 
connection and leave the actions behind the configured keys unusable after a Microsoft Teams Windows client update.

The present script will try to locate the current Microsoft Teams installation location, the selected Streamdeck profile JSON settings file and update its associated AppIdentifier accordingly.

## REQUIREMENTS:
- Streamdeck2 application for Windows must be correctly installed
- Microsoft Teams (work or school) client for Windows must be correctly installed for the current user
- The name of the Streamdeck2 profile (which contains the Microsoft Teams related key actions)
  must be provided in the $StreamDeckTeamsProfileName variable in the first section of the script.
- A system restart might be required.

## IMPORTANT NOTES:
1) Please backup your current Streamdeck2 profile settings before using this script.
2) The path update section of the script is commented out by default for safety purposes. Uncomment it to act as intended after understanding what the script does.
3) If run without uncommenting the above mentioned section, the script will just detail the actions to be done (~ WhatIf mode).
4) If you need to fix the profile manually, please locate and select the appropriate application in the Preferences section of the Streamdeck2 application:

![image](https://github.com/rito2k/UpdateTeamsStreamdeckProfile/assets/26970701/23579e42-44c0-46de-8559-0d0d012371e3)


## DISCLAIMER:
The script is provided AS IS without warranty of any kind. I do not take any responsability on it's use.

The entire risk arising out of the use of the script and documentation remains with you. In no event shall I or anyone else involved in the creation, development
or delivery of the script be liable for any damages whatsoever (including, without limitation, damages for loss of personal/business profits, personal/business interruption, 
loss of personal/business information, or other pecuniary loss) arising out of the use of or inability to use the script or documentation.
