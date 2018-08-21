Param (
        [parameter(Mandatory = $true, ValueFromPipeline=$true)]
        [String]$DriveLetter,

        [parameter(Mandatory = $false)]
        [int]$DaysToKeep=30
)

$DeviceID = (Get-WmiObject -Class Win32_Volume |? {$_.DriveLetter -eq $driveletter}).DeviceID
$copies = Get-WmiObject -Class win32_shadowcopy | ? {$_.VolumeName -eq $DeviceID} |select deviceobject,ID,@{n='datetime';e={[management.managementDateTimeConverter]::ToDateTime($_.installdate)}},@{n='dayofyear';e={[management.managementDateTimeConverter]::ToDateTime($_.installdate).dayofyear}}  |?{$_.datetime -lt (Get-Date).AddDays(-$DaysToDelete)}
foreach ($copy in $copies)
{
    ((Get-WmiObject -Class win32_shadowcopy) |? {$_.ID -eq $copy.id}).delete()
    Write-host $copy deleted
}