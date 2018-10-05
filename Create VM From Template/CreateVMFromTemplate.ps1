#Create New VMWare VM From Template
#Author: Tim Grieve
#Date: 30 September 2018

#These Commands rely on the vmware.vimAutomation.core module being installed
Install-module vmware.vimAutomation.core

#Connect to Virtual Center Server
$VCenter = Read-Host "Enter name of vcenter server to manage"
Connect-VIServer -Server $VCenter -force

#Import VM Settings from csv file in same folder as script
$VMSettings = Import-Csv .\InputVMComputeSettings.csv

#Import Required Hard Disks from csv file in same folder as script
$VMDisks = Import-Csv .\InputAdditionalVMDisks.csv

#Get Resource Pool
$Resources = Get-ResourcePool -ID $VMSettings.ResourcePool

#Get Template Name
$TemplateName = Read-Host "Enter Name of VM Template to Create VM from"
$Template = Get-Template -Name $TemplateName

#Create New VM
New-VM -Name $VMSettings.vmname -Template $Template -Datastore $VMSettings.Datastore -ResourcePool $Resources

#Get VMNAME
$VM = Get-VM -Name $VMSettings.vmname

#Create Additional Hard Disks
ForEach ($Disk in $VMDisks)
{
	$VM | New-HardDisk -CapacityGB $Disk.DiskSizeGB -StorageFormat Thick
}

#Set Custom VM Settings
#If using an OSCustomizationSpec uncomment the commands below.

#Load Credentials to Join New VM to domain use Get_AD_Credentials.ps1 to generate JoinDomainCred.xml file
#$Credential = Import-CliXml -Path .\JoinDomainCred.xml

#$CustomSpec = Read-Host "Enter the name of Customization File to use" 
#$VM | Set-VM -OSCustomizationSpec $CustomSpec
