#=================================================================
# Author:           Jochen Renner
# Script Name:      QuerySCOMDB.ps1
# Date:             12.03.2018
# Version:          1.0
# Comment:          
#==============================================================
Param ([string]$SQLScript, [int]$SQLQueryTimeout)

#Connect to the DB engine
$DBServer = (Get-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\System Center\2010\Common\Database' -Name DatabaseServerName).DatabaseServerName
$Database = (Get-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\System Center\2010\Common\Database' -Name DatabaseName).DatabaseName
$connString = "Server=$DBServer;Integrated Security=true;Initial Catalog=$Database"

$conn = New-Object System.Data.SqlClient.SqlConnection($connString)
$conn.Open()

#execute SQL Query
$command = $conn.CreateCommand()
$command.CommandText = $SQLScript
$command.CommandTimeout = $SQLQueryTimeout
$Reader = $command.ExecuteReader()
$Datatable = New-Object System.Data.DataTable
$Datatable.Load($Reader)

#Close SQL Connection
$conn.Close()

#Create Output
If ($Datatable -ne $null) 
{
	Write-Output $Datatable | ft -Wrap
}
else
{
	Write-Output "no output from Query"
}
