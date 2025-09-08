# Define menu options
$menuOptions = @(
    "Document the system",
    "Enable updates",
    "User Auditing",
    "Exit"
)

# Define functions for each option
function Document-System {
    Write-Host "`n--- Starting: Document the system ---`n"
}

function Enable-Updates {
    Write-Host "`n--- Starting: Enable updates ---`n"
}

function User-Auditing {
    Write-Host "`n--- Starting: User Auditing ---`n"
      function User-Auditing {
        Write-Host "`n--- Starting: User Auditing ---`n"
    
        # Get all local user accounts except built-in accounts
        $users = Get-LocalUser | Where-Object { $_.Name -ne "Administrator" -and $_.Name -ne "DefaultAccount" -and $_.Name -ne "Guest" -and $_.Name -ne "WDAGUtilityAccount" }
    
        foreach ($user in $users) {
            $prompt = "Is '$($user.Name)' an Authorized User? [Y/n]: "
            $answer = Read-Host -Prompt $prompt
    
            if ($answer -eq "" -or $answer -match "^[Yy]$") {
                Write-Host "'$($user.Name)' kept."
            } elseif ($answer -match "^[Nn]$") {
                try {
                    Remove-LocalUser -Name $user.Name -ErrorAction Stop
                    Write-Host "'$($user.Name)' has been deleted." -ForegroundColor Red
                } catch {
                    Write-Host "Failed to delete '$($user.Name)': $_" -ForegroundColor Yellow
                }
            } else {
                Write-Host "Invalid input. Keeping '$($user.Name)'."
            }
        }  
}

# Menu loop
:menu do {
    Write-Host "`nSelect an option:`n"
    for ($i = 0; $i -lt $menuOptions.Count; $i++) {
        Write-Host "$($i + 1). $($menuOptions[$i])"
    }

    $selection = Read-Host "`nEnter the number of your choice"

    switch ($selection) {
        "1" { Document-System }
        "2" { Enable-Updates }
        "3" { User-Auditing }
        "4" { Write-Host "`nExiting..."; break menu }  # leave the do{} loop
        default { Write-Host "`nInvalid selection. Please try again." }
    }
} while ($true)
