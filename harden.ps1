# =========================
# Variables Section - START
# =========================
$MaxPasswordAge    = 60   # maximum days before a password must be changed
$MinPasswordAge    = 10   # minimum days a password must be used
$MinPasswordLength = 10   # minimum length of passwords
$PasswordHistory   = 20   # number of previous passwords remembered
$LockoutThreshold  = 5    # bad logon attempts before lockout
$LockoutDuration   = 10   # minutes an account remains locked
$LockoutWindow     = 10   # minutes in which bad logons are counted
# =======================
# Variables Section - END
# =======================


# Single-line comment: This is a single-line comment at the top of the script

<#
Multi-line comment:
This script provides a menu for Windows 11 hardening tasks.
You can select options to perform various security actions.
#>

# Define the menu options

# Check for Administrator privileges and relaunch if needed
if (-not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Write-Host "Script is not running as Administrator. Attempting to relaunch with elevated privileges..."
    $psi = New-Object System.Diagnostics.ProcessStartInfo
    $psi.FileName = "powershell.exe"
    $psi.Arguments = "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`""
    $psi.Verb = "runas"
    try {
        [System.Diagnostics.Process]::Start($psi) | Out-Null
    } catch {
        Write-Host "Failed to restart as Administrator. Exiting."
    }
    exit
}

# ...existing code...
$menuOptions = @(
    "Document the system",
    "Enable updates",
    "User Auditing",
    "Account Policies",
    "Local Policies",
    "Defensive Countermeasures",
    "Uncategorized OS Settings",
    "Service Auditing",
    "OS Updates",
    "Application Updates",
    "Prohibited Files",
    "Unwanted Software",
    "Malware"
    "Application Security Settings"
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

    Write-Host "`n--- Starting: Administrator Group Auditing ---`n"

    # Get all members of the local Administrators group
    $adminGroup = [ADSI]"WinNT://./Administrators,group"
    $members = @($adminGroup.psbase.Invoke("Members")) | ForEach-Object {
        $_.GetType().InvokeMember("Name", 'GetProperty', $null, $_, $null)
    }

    foreach ($member in $members) {
        $prompt = "Is '$member' an Authorized Administrator? [Y/n]: "
        $answer = Read-Host -Prompt $prompt

        if ($answer -eq "" -or $answer -match "^[Yy]$") {
            Write-Host "'$member' kept in Administrators group."
        } elseif ($answer -match "^[Nn]$") {
            try {
                net localgroup Administrators "$member" /delete
                Write-Host "'$member' has been removed from Administrators group." -ForegroundColor Red
            } catch {
                Write-Host "Failed to remove '$member': $_" -ForegroundColor Yellow
            }
        } else {
            Write-Host "Invalid input. Keeping '$member' in Administrators group."
        }
    }
}

function Account-Policies {
    Write-Host "`n--- Starting: Account Policies ---`n"
    Write-Host "Setting maximum password age to $MaxPasswordAge days..."
    net accounts /maxpwage:$MaxPasswordAge
    $MaxPasswordAge    = 60   # maximum days before a password must be changed
$MinPasswordAge    = 10   # minimum days a password must be used
$MinPasswordLength = 10   # minimum length of passwords
$PasswordHistory   = 20   # number of previous passwords remembered
$LockoutThreshold  = 5    # bad logon attempts before lockout
$LockoutDuration   = 10   # minutes an account remains locked
$LockoutWindow     = 10   # minutes in which bad logons are counted
}

function Local-Policies {
    Write-Host "`n--- Starting: Local Policies ---`n"
}

function Defensive-Countermeasures {
    Write-Host "`n--- Starting: Defensive Countermeasures ---`n"
}

function Uncategorized-OS-Settings {
    Write-Host "`n--- Starting: Uncategorized OS Settings ---`n"
}

function Service-Auditing {
    Write-Host "`n--- Starting: Service Auditing ---`n"
}

function OS-Updates {
    Write-Host "`n--- Starting: OS Updates ---`n"
}

function Application-Updates {
    Write-Host "`n--- Starting: Application Updates ---`n"
}

function Prohibited-Files {
    Write-Host "`n--- Starting: Prohibited Files ---`n"
}

function Unwanted-Software {
    Write-Host "`n--- Starting: Unwanted Software ---`n"
}

function Malware {
    Write-Host "`n--- Starting: Malware ---`n"
}

function Application-Security-Settings {
    Write-Host "`n--- Starting: Application Security Settings ---`n"
}


# Menu loop
$exit = $false
while (-not $exit) {
    Write-Host "`nSelect an option:`n"
    for ($i = 0; $i -lt $menuOptions.Count; $i++) {
        Write-Host "$($i + 1). $($menuOptions[$i])"
    }

    $selection = Read-Host "`nEnter the number of your choice"

    switch ($selection) {
        "1" { Document-System }
        "2" { Enable-Updates }
        "3" { User-Auditing }
        "4" { Account-Policies }
        "5" { Local-Policies }
        "6" { Defensive-Countermeasures }
        "7" { Uncategorized-OS-Settings }
        "8" { Service-Auditing }
        "9" { OS-Updates }
        "10" { Application-Updates }
        "11" { Prohibited-Files }   
        "12" { Unwanted-Software }
        "13" { Malware }
        "14" { Application-Security-Settings }
        "15" { Write-Host "`nExiting..."; $exit = $true }
        default { Write-Host "`nInvalid selection. Please try again." }
    }
}