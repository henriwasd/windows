# --- Variables ---

$targetLanguage = "en-US" # Replace with the desired language code (e.g., "en-US", "fr-FR")

# --- Install Language Pack ---

# Ensure you have the necessary language pack on your system or a local repository

# You can use Add-WindowsCapability -Online -Name "Language.es-ES~..." for feature-on-demand languages or install the pack from a local ISO [5, 11]

# Example using Install-Language cmdlet:

Install-Language -Language $targetLanguage

# --- Set User Display Language ---

# This sets the language for the current user

Set-WinUserLanguageList $targetLanguage -Force

# --- Copy Settings to System and Welcome Screen ---

# This applies the language to the system and the welcome screen

# You may need to run this section in a separate user session for it to fully apply

# Or use a scheduled task to run it under the logged-on user [7, 9]

Copy-UserInternationalSettingsToSystem -WelcomeScreen $True

# --- Force a Restart to Apply Changes ---

# A reboot is required for the changes to take effect system-wide [1, 9]

Restart-Computer -Force
