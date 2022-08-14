<#

.NAME
	GetSqlDbLoginAccess_FRM.PS1	
.SYNOPSIS
	SCRIPT DEVELOPED TO CONNECT TO SQL DATABASES

.DESCRIPTION

.PARAMETERS 
	$srvinstance    :  SQL Server Instance to work	
	$username       :  DatabaseUser with credentials to logon as sysadmin
	$Authentication :  Login Authentication - Windows or SQL Server 
	$userPassword   :  Password of Database User

.VARIABLES
	
.INPUTS
	
.OUTPUTS
	Console Error Message

.REQUIREMENTS
	Powershell Ver 3.0 or Higher
	
.EXAMPLE
 Ps c:\> .\GetSqlDbLoginAccess_FRM.PS1

.NOTES
	Author        :	Javier Montero / SQL-Oracle DBA Developer / 09/15/2016
	Company       : Amphora Inc.
	Department    : IT - Databases
    Version       :	1.0	
	Compatibility :	PS 3.0 or Higher
	SQL Ver       :	SQL Server 2008R2 or Higher
	VS IDE        : Visual Studio 2015   
	TO GET HELP OR OTHER INFORMATION ABOUT THIS CODE TYPE GET-HELP .\GetSqlDbLoginAccess_FRM.PS1
	
#>

    ################################################ Variables
$LastLogonDetails   = @()

	################################################ PowerShell Version Validation 	
	if($PSVersionTable.PSVersion.Major -lt 3){
	[System.Windows.Forms.MessageBox]::Show("This Form Cannot be used in this system, PowerShell V3.0 or higher is required","Amphora Inc. - Error",0);
	Exit;
}
try{
	############################################################ Loading Assemblies
	Add-Type -AssemblyName "System.Drawing" -ErrorAction Stop;
	Add-Type -AssemblyName "System.Windows.Forms" -ErrorAction Stop;	
}
	Catch [System.UnauthorizedAccessException]{
		Write-Warning -Message "Access Denied when Attempting to Load Required Assemblies"; Break;
	}
	catch [System.Exception]{
		Write-Warning -Message "Unable to Load Required Assemblies. Error Message:$($_.Exception.Message) "; Break;
	}

function GetLastLogon{
	try {
		$LastLogonDetails = GetLastLogonDetails
		
		if($LastLogonDetails){
			if($objSrvInstanceCmb.Items.Count -gt 0){
				$objSrvInstanceCmb.SelectedItem = $LastLogonDetails.ServerInstance
			}
			else {
				if ($LastLogonDetails.Authentication -eq "SQL Authentication") {
				$objSrvInstanceCmb.SelectedItem = $LastLogonDetails.ServerInstance
				[int]$index = $objAuthenticationCmb.Items.IndexOf($LastLogonDetails.Authentication)
				$objAuthenticationCmb.SelectedItem = $LastLogonDetails.Authentication
				$objUserTXT.ReadOnly = $false
				$objPasswordTXT.ReadOnly = $false
				$objUserTXT.Text = $LastLogonDetails.UserName
				$objPasswordTXT.Text = $LastLogonDetails.Password
				$objSaveDetChkbox.Checked = $LastLogonDetails.Checked				
				}
				else {
					$objSrvInstanceCmb.SelectedItem = $LastLogonDetails.ServerInstance
					$objAuthenticationCmb.SelectedItem = $LastLogonDetails.Authentication
					$objUserTXT.ReadOnly = $false
					$objPasswordTXT.ReadOnly = $false
					$objUserTXT.Text = ""
					$objPasswordTXT.Text = ""
					$objSaveDetChkbox.Checked = $LastLogonDetails.Checked
				}	
			}			
		}
	}
	catch [System.Exception] {
		Write-Warning -Message "Error Gathering Last Logon Information"
		Throw
	}
}
function SaveConnection{
	Param(
		[Parameter(Mandatory=$true, Position=0)]
		[String]$ServerInstance,
		[Parameter(Mandatory=$true, Position=1)]
		[String]$Authentication,
		[Parameter(Mandatory=$true, Position=2)]
		[String]$UserName,
		[Parameter(Mandatory=$false, Position=3)]
		[String]$Password,
		[Parameter(Mandatory=$true, Position=4)]
		[bool]$Save
	)
	try {
		if($Save){
			SaveCredentials -ServerInstance $ServerInstance -Authentication $Authentication -UserName $UserName -Password $Password | Out-Null
			LastLogonTime -ServerInstance $ServerInstance -Authentication $Authentication -UserName $UserName | Out-Null
		}
		else{
			LastLogonTime -ServerInstance $ServerInstance -Authentication $Authentication -UserName $UserName | Out-Null
		}
		
	}
	catch [System.Exception] {
		Throw
	}
}
function GetDbConnectionInfo{
	
	#region - Variables	
	    $UserSavedDetails                   = GetUserEnvironments <# --> Retrieving Saved Credentials #>
		[string]$Script:srvInstance         = $null
		[string]$Script:Login               = $null
		[string]$script:Password            = $null
		[string]$Script:dbName              = $null
		[string]$Script:Authentication      = $null
		$Script:ConnStringArray             = New-Object -TypeName System.Collections.ArrayList
		$SrvCmbOptions                      = @()
		[bool]$Script:SaveConn              = $false                 

	#endregion - Variables

		if($UserSavedDetails){
			foreach($item in $UserSavedDetails){
				$SrvCmbOptions	+= $item.ServerInstance							 
			}
		}
		
	

	try{		
		#region - Handlers
		$handler_objAuthenticationCmb_SelectedIndexChanged={
			if($objAuthenticationCmb.Text -eq "Windows Authentication"){
				$objUserTXT.ReadOnly = $true;
				$objPasswordTXT.ReadOnly = $true;
				$objUserTXT.Text = "";
				$objPasswordTXT.Text = "";
			}
			else{
				$objUserTXT.ReadOnly = $false;
				$objPasswordTXT.ReadOnly = $false;
				$objUserTXT.Text = "";
				$objPasswordTXT.Text = "";
			}
		}

		$handler_objSrvInstanceCmb_SelectedIndexChanged={
			try {
				$optSelected = $objSrvInstanceCmb.Text 
				
				if($UserSavedDetails.ServerInstance -contains $optSelected){
					$pos = [Array]::IndexOf($UserSavedDetails.ServerInstance,$optSelected)
					$auth = $UserSavedDetails[$pos].Authentication
					if($auth -eq "SQL Authentication"){
						$objSrvInstanceCmb.SelectedItem = $UserSavedDetails[$pos].ServerInstance
						$objAuthenticationCmb.SelectedItem = $auth
						$objUserTXT.ReadOnly = $false
						$objPasswordTXT.ReadOnly = $false
						$objUserTXT.Text = $UserSavedDetails[$pos].UserName
						$objPasswordTXT.Text = $UserSavedDetails[$pos].Password
						$objSaveDetChkbox.Checked = $UserSavedDetails[$pos].Checked
						#$authpos = $objAuthenticationCmb.Items.IndexOf($auth)						
					}
					else {
						$objSrvInstanceCmb.SelectedItem = $UserSavedDetails[$pos].ServerInstance
						$objAuthenticationCmb.SelectedItem = $auth
						$objUserTXT.ReadOnly = $true
						$objPasswordTXT.ReadOnly = $true
						$objUserTXT.Text = ""
						$objPasswordTXT.Text = ""
						#$objSaveDetChkbox.Checked = $true
						$objSaveDetChkbox.Checked = $UserSavedDetails[$pos].Checked
					}					
				}
			}
			catch [System.Exception] {
				throw
			}
		}
		$handler_objOKButton_Click={
			$Script:srvInstance = $objSrvInstanceCmb.Text; 
			$Script:Authentication = $objAuthenticationCmb.Text; 
			$Script:Login = $objUserTXT.Text; 
			$script:Password = $objPasswordTXT.Text; 
			if($objSaveDetChkbox.Checked){
				$Script:SaveConn = $true
			}
			$objForm.Close();
		}

		$handler_objCancelButton_Click={
			$Script:Authentication = "Exit"
			$objForm.Close()
			Write-Host "PS is the Best bye bye, JM"					
		}
		
		#endregion - Handlers

		#region - Form
		################################################ Form Creation
		$objForm = New-Object System.Windows.Forms.Form;
		$objForm.Size = New-Object System.Drawing.Size(400,320);
		$objForm.text ="Database Login Access";
		#endregion - Form

		#region - Buttons
		$objOKButton = New-Object System.Windows.Forms.Button;
		$objOKButton.Location = New-Object System.Drawing.Size(100, 240);
		$objOKButton.Size = New-Object System.Drawing.Size(90, 20);
		$objOKButton.Text = "OK"
		$objOKButton.Add_Click($handler_objOKButton_Click)
		$objOKButton.TabIndex = 5
		$objOKButton.Font = New-Object -TypeName System.Drawing.Font("Microsoft Sans Serif",8.25,[System.Drawing.FontStyle]::Bold)
		$objForm.Controls.Add($objOKButton);

		$objCancelButton = New-Object -TypeName System.Windows.Forms.Button
		$objCancelButton.Location = New-Object -TypeName System.Drawing.Size(200,240)
		$objCancelButton.Height = 20
		$objCancelButton.Width = 90
		$objCancelButton.Text = "Close"
		$objCancelButton.TabIndex = 6
		$objCancelButton.Font = New-Object -TypeName System.Drawing.Font("Microsoft Sans Serif",8.25,[System.Drawing.FontStyle]::Bold)
		$objCancelButton.Add_Click($handler_objCancelButton_Click)
		$objForm.Controls.Add($objCancelButton)
		#endregion - Buttons

		#region - Labels 
		$objsrvlbl = New-Object System.Windows.Forms.Label;
		$objsrvlbl.Location = New-Object System.Drawing.Size(160,20);
		$objsrvlbl.Size = New-Object System.Drawing.Size(100,20);
		$objsrvlbl.Text = "Server Instance:";
		$objsrvlbl.Font = New-Object -TypeName System.Drawing.Font("Microsoft Sans Serif",8.25,[System.Drawing.FontStyle]::Bold)
		$objForm.Controls.Add($objsrvlbl);

		$objauthenlbl = New-Object System.Windows.Forms.Label;
		$objauthenlbl.Location = New-Object System.Drawing.Size(165,75);
		$objauthenlbl.Size = New-Object System.Drawing.Size(100,20);
		$objauthenlbl.Text = "Authentication:";
		$objauthenlbl.Font = New-Object -TypeName System.Drawing.Font("Microsoft Sans Serif",8.25,[System.Drawing.FontStyle]::Bold)
		$objForm.Controls.Add($objauthenlbl);

		$objuserlbl = New-Object System.Windows.Forms.Label;
		$objuserlbl.Location = New-Object System.Drawing.Size(180,120);
		$objuserlbl.Size = New-Object System.Drawing.Size(100,20);
		$objuserlbl.Text = "Login ID:";
		$objuserlbl.Font = New-Object -TypeName System.Drawing.Font("Microsoft Sans Serif",8.25,[System.Drawing.FontStyle]::Bold)
		$objForm.Controls.Add($objuserlbl);

		$objpasslbl = New-Object System.Windows.Forms.Label;
		$objpasslbl.Location = New-Object System.Drawing.Size(180,170);
		$objpasslbl.Size = New-Object System.Drawing.Size(100,20);
		$objpasslbl.Text = "Password:";
		$objpasslbl.Font = New-Object -TypeName System.Drawing.Font("Microsoft Sans Serif",8.25,[System.Drawing.FontStyle]::Bold)
		$objForm.Controls.Add($objpasslbl);

		#endregion - Labels 

		#region - Textboxes
		<#$objServerTXT = New-Object System.Windows.Forms.TextBox;
		$objServerTXT.Location = New-Object System.Drawing.Size(100, 40);
		$objServerTXT.Size = New-Object System.Drawing.Size(200, 20);
		$objServerTXT.TabIndex = 0;
		$objForm.Controls.Add($objServerTXT);#>

		$objUserTXT = New-Object System.Windows.Forms.TextBox;
		$objUserTXT.Location = New-Object System.Drawing.Size(100, 140);
		$objUserTXT.Size = New-Object System.Drawing.Size(200, 20);
		$objUserTXT.TabIndex = 2;
		$objUserTXT.ReadOnly = $true;
		$objForm.Controls.Add($objUserTXT);

		$objPasswordTXT = New-Object System.Windows.Forms.TextBox;
		$objPasswordTXT.Location = New-Object System.Drawing.Size(100, 190);
		$objPasswordTXT.Size = New-Object System.Drawing.Size(200, 20);
		$objPasswordTXT.TabIndex = 3;
		$objPasswordTXT.UseSystemPasswordChar = $true;
		$objPasswordTXT.ReadOnly = $true;
		$objForm.Controls.Add($objPasswordTXT);

		#endregion - Textboxes
		
		#region - CheckBoxes
		$objSaveDetChkbox = New-Object -TypeName System.Windows.Forms.CheckBox
		$objSaveDetChkbox.Location = New-Object -TypeName System.Drawing.Size(150,210)
		$objSaveDetChkbox.Text = "Save Connection"
		$objSaveDetChkbox.Size = New-Object -TypeName System.Drawing.Size(150,20)
		$objSaveDetChkbox.TabIndex = 4
		$objSaveDetChkbox.Font = New-Object -TypeName System.Drawing.Font("Microsoft Sans Serif",8.25,[System.Drawing.FontStyle]::Bold)
		$objSaveDetChkbox.Checked = 0
		$objForm.Controls.Add($objSaveDetChkbox)
		#endregion - CheckBoxes

		#region - ComboBox
		$objSrvInstanceCmb = New-Object -TypeName System.Windows.Forms.ComboBox
		$objSrvInstanceCmb.Location = New-Object -TypeName System.Drawing.Size(100,40)
		$objSrvInstanceCmb.Size = New-Object -TypeName System.Drawing.Size(200,20)
		$objSrvInstanceCmb.Items.AddRange($SrvCmbOptions)
		$objSrvInstanceCmb.TabIndex = 0
		$objSrvInstanceCmb.Add_SelectedIndexChanged($handler_objSrvInstanceCmb_SelectedIndexChanged)
		$objForm.Controls.Add($objSrvInstanceCmb)
		
		if(($SrvCmbOptions -eq "") -or ($SrvCmbOptions -eq $null) -or ($SrvCmbOptions -eq @())){
			$objSrvInstanceCmb.Items.Insert(0, 	"Type or Choose a Server Instance")
			$objSrvInstanceCmb.SelectedIndex = 0;
		}		

		$CmbOptions = "Windows Authentication", "SQL Authentication";
		$objAuthenticationCmb = New-Object System.Windows.Forms.ComboBox;
		$objAuthenticationCmb.Items.AddRange($CmbOptions);
		$objAuthenticationCmb.SelectedIndex = 0;
		$objAuthenticationCmb.Location = New-Object System.Drawing.Size(100, 95);
		$objAuthenticationCmb.Size = New-Object System.Drawing.Size(200,20);
		$objAuthenticationCmb.TabIndex = 1;
		$objAuthenticationCmb.Add_SelectedIndexChanged($handler_objAuthenticationCmb_SelectedIndexChanged);
		$objForm.Controls.Add($objAuthenticationCmb);
		#endregion - ComboBox
		
		#region - GatheringLastLogonInfo
		GetLastLogon | Out-Null
		#endregion - GatheringLastLogonInfo

		#region - LoadForm
		$objForm.Top = $true;
		$objForm.StartPosition = "CenterScreen";
		$objForm.Add_Shown({$objForm.Activate()});
		$objForm.ShowDialog() | Out-Null;
		#endregion - LoadForm

		#region - Filled Up ConnectionString Array
		if($Authentication -eq "Windows Authentication"){
			if($srvInstance){
				try{
					$conn = New-Object System.Data.SqlClient.SqlConnection;
					$conn.ConnectionString = "Server=$srvInstance;Database=master;Integrated Security=True";
					$conn.Open();
					Write-Host "Logon Values are OK";
					$conn.Close();
					$pUser = [Environment]::UserDomainName+"\"+[Environment]::UserName
					SaveConnection -ServerInstance $srvInstance -Authentication $Authentication -UserName $pUser -Password $script:Password -Save $Script:SaveConn
					[array]$ConnStringArray += $Script:srvInstance
					[array]$ConnStringArray += $Script:Authentication
					[array]$ConnStringArray += $pUser
					[array]$ConnStringArray += "@@@"
					 
					return ,$ConnStringArray;
				}
				catch [System.Exception]{
					$errorcatch = $_.Exception.Message
					Write-Warning -Message "Unable to Login on $srvInstance, Please Validate your inputs that you have provided";
					$Script:srvInstance = "@@@"
					[array]$Script:ConnStringArray += "@@@";
					[array]$Script:ConnStringArray += "@@@";
					[array]$Script:ConnStringArray += "@@@";
					[array]$Script:ConnStringArray += "@@@";
					return ,$ConnStringArray;
				}
			}
			else{
				Write-Host "Missing Server Instance Value";
				[array]$ConnStringArray += "@@@";
				[array]$ConnStringArray += "@@@";
				[array]$ConnStringArray += "@@@";
				[array]$ConnStringArray += "@@@";
				return ,$ConnStringArray;
			}
		}
		elseif ($Script:Authentication -eq "Exit") {
			[array]$ConnStringArray += "000";
			return ,$ConnStringArray;
		}
		else{
			if($Login -and $Password -and $srvInstance){
				try{
					$conn = New-Object System.Data.SqlClient.SqlConnection;
					$conn.ConnectionString = "Server=$srvInstance;Database=master;User=$Login;Password=$Password;Integrated Security=False ";
					$conn.Open();
					Write-Host "Logon Values are OK";
					$conn.Close();
					SaveConnection -ServerInstance $srvInstance -Authentication $Authentication -UserName $Script:Login -Password $script:Password -Save $Script:SaveConn
					[array]$ConnStringArray += $Script:srvInstance
					[array]$ConnStringArray += $Script:Authentication 
					[array]$ConnStringArray += $Script:Login 
					[array]$ConnStringArray += $script:Password
					#Write-Host $ConnStringArray[0]
					return ,$ConnStringArray;
					
				}
				catch [System.Exception]{
					$errorcatch = $_.Exception.Message
					Write-Warning -Message "Failed to Login into Server $srvInstance with User Credentials for $Login. Please validate your inputs Server, Login and Password. Error Message: $($_.Exception.Message)"
					$Script:srvInstance = "@@@"
					[array]$ConnStringArray += "@@@";
					[array]$ConnStringArray += "@@@";
					[array]$ConnStringArray += "@@@";
					[array]$ConnStringArray += "@@@";
					return ,$ConnStringArray;
				}					
			}
			else{
				Write-Host "Missing Inputs for Server Instance, Login or Password. Please Validate and try again";
				[array]$ConnStringArray += "@@@";
				[array]$ConnStringArray += "@@@";
				[array]$ConnStringArray += "@@@";
				[array]$ConnStringArray += "@@@";
				return ,$ConnStringArray;
			}
		}	
		#endregion - Fill Up ConnectionString Array
		}
	catch [System.Exception]{
		Write-Warning -Message "Error Loading Database Access Login Form. Error Message: $($_.Exception.Message)";
		[array]$ConnStringArray = "@@@";
		[array]$ConnStringArray += "@@@";
		return ,$ConnStringArray;
		}

}
	


