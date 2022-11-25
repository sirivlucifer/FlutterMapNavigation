# Current Directory Game Files
$InstallGame = Get-ItemPropertyValue "HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\Steam App 261550" -name "InstallLocation" -ErrorAction SilentlyContinue

# ErrorMessage Reset
$ErrorMessage = $null

# Check Admin Mode
$currentPrincipal = New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())
$ADMIN = $currentPrincipal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)

if ($ADMIN -eq "True")
    {
    # Check if directory Game Found
    if ($InstallGame -match "Mount & Blade II Bannerlord")
        {
        cls
        "###########################"
        "# MODULE UNBLOCK DDL v1.3 #"
        "###########################"
        ""
        "File being checked. Please wait..."
        
        
        $AllFolders = Get-ChildItem "$InstallGame\Modules" -directory -recurse | Where { (Get-ChildItem $_.fullName).count -ge 1 }
        $FilesBlocked = @()
        foreach ($Folder in $AllFolders)
            {
            $CurrentDirectory = $Folder.Fullname
            try
                {
                $FilesBlocked += @((Get-Item $CurrentDirectory\* -Stream zone* -ErrorAction Stop).FileName)
                }
            catch
                {
                $ErrorMessage += @($_.Exception.Message)
                }
            }

        if ($FilesBlocked -match "[A-Z]")
            {
            try
                {
                foreach ($File in $FilesBlocked)
                    {
                    if ($File -match "[A-Z]")
                        {
                        Unblock-File $File
                        }
                    }
                }
            catch
                {
                $ErrorMessage += @($_.Exception.Message)
                }
            }

        else
            {
            cls
            "###########################"
            "# MODULE UNBLOCK DDL v1.3 #"
            "###########################"
            ""
            "No files currently locked. Everything ok"
            ""
            pause
            exit
            }

        if ($ErrorMessage -match "[A-Z]")
            {
            cls
            "###########################"
            "# MODULE UNBLOCK DDL v1.3 #"
            "###########################"
            ""
            "Impossible unblock this dll(s) file(s) :"
            $ErrorMessage
            ""
            pause
            exit
            }
        
        else
            {
            cls
            "###########################"
            "# MODULE UNBLOCK DDL v1.3 #"
            "###########################"
            ""
            "Scrit successfully unblocked the files below : "
            $FilesBlocked
            ""
            pause
            exit
            }

        }

    else
        {
        cls
        "###########################"
        "# MODULE UNBLOCK DDL v1.3 #"
        "###########################"
        ""
        "This script could not find the location of the game. Please verify that your game is installed correctly."
        ""
        pause
        exit
        }
    }
else
    {
    cls
    "###########################"
    "# MODULE UNBLOCK DDL v1.3 #"
    "###########################"
    ""
    "This script was not launched as an administrator. Please verify that your Windows account has administrator rights."
    ""
    pause
    exit
    }
