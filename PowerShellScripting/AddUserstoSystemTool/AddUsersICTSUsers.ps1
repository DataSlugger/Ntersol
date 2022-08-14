<#
.DESCRIPTION


.NOTES
    Author        :	Javier Montero  - 10/17/2016
    Version       :	1.0	
	Compatibility :	PS 3.0 or Higher
	SQL Ver       :	SQL Server 2008R2 or Higher
	VS IDE        : Visual Studio Code   
	TO GET HELP OR ANY NOTE HERE TYPE GET-HELP .\AddUsersICTSUser.PS1 -FULL

.EXAMPLE 
    PSprompt> .\AddUsersICTSUser.PS1

#>

#region - Variables

$pwdMainPath    = $PWD.Path;
$loginValues    = New-Object -TypeName System.Collections.ArrayList;

try {
     [Reflection.Assembly]::LoadWithPartialName("System.Windows.Forms") 
     [Reflection.Assembly]::LoadWithPartialName("System.Drawing")
}
Catch [System.UnauthorizedAccessException]{
		Write-Warning -Message "Access Denied when Attempting to Load Required Assemblies"; Break;
	}
catch [System.Exception] {
    Write-Warning -Message "Unable to Load Required Assemblies. Error Message:$($_.Exception.Message) "; Break;
}

#endregion - Variables

#region - Functions

function ValidatePSModulePath{

    try {
        $ScripRootPath = $pwdMainPath
        if ($ScripRootPath) {
            $DOCDIR = [System.Environment]::GetFolderPath("MyDocuments")
            $DESTDIRPATH = "$DOCDIR\WindowsPowerShell"

            Write-Host "Creating Destination Directory if it does not exits..."
            if(!(Test-path -path $DESTDIRPATH)){
                New-Item -Path $DESTDIRPATH -ItemType Directory
            }
            
            $DESTMODULESDIRPATH = "$DESTDIRPATH\MODULES"

            Write-Host "Creating Modules Destination Directory $DESTMODULESDIRPATH if it does not exits..."
            IF(!(Test-Path -Path $DESTMODULESDIRPATH)){
                New-Item -Path $DESTMODULESDIRPATH -ItemType Directory
            }

            Write-Host "Copying Latest Modules Files Version"
            Set-location $ScripRootPath;
            Set-Location "$ScripRootPath\PowerShellModules"

            $PSModules_SRCDIR = $pwd.Path
            $SRCPATH = "$PSModules_SRCDIR\ADDUSERSTOSYSTEMTOOL"
            Copy-Item -Path $SRCPATH -Destination $DESTMODULESDIRPATH -Force -Recurse

            Set-Location $ScripRootPath

        }    
    }
    catch [System.UnauthorizedAccessException]{
        [System.Windows.Forms.MessageBox]::Show("Access Denied when Attempting to Create/Copy Folder Modules")
	    Write-Warning -Message "Access Denied when Attempting to Create/Copy Folder Modules"; Break;
    }
    catch [System.Exception] {
        [System.Windows.Forms.MessageBox]::Show("$_.Exception.Message")
	    Exit
    }
    
}

function FormCreation{
    try {

        #region - Handlers
        #endregion - Handlers

        #region - MainForm
        $objForm = New-Object -TypeName System.Windows.Forms.Form
        $objForm.Height = 300
        $objForm.Width = 400
        $objForm.FormBorderStyle = 'FixedDialog'
        $objForm.Text = "Adding users to ICTS System"
        $objForm.StartPosition = 'CenterPosition'

        #endregion - MainForm

        #region - GroupBox
        $objGroupBox1 = New-Object -TypeName System.Windows.Forms.GroupBox
        $objGroupBox1.Location = New-Object -TypeName System.Drawing.Size(5,10)
        $objGroupBox1.Width = 150
        $objGroupBox1.Height = 150
        $objGroupBox1.Text = "SQL Server Logins"
        $objForm.Controls.Add($objGroupBox1)
        #endregion - GroupBox

        #region - Labels
        $Label1 = New-Object -TypeName System.Windows.Forms.Label
        $Label1.Height = 20
        $Label1.Width = 50
        $Label1.Location = New-Object -TypeName System.Drawing()
        #endregion - Labels

    }
    catch [System.Exception] {
        
    }
}

#endregion - Functions
