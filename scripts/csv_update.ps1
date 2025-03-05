
<#
    .SYNOPSIS
    SEC.gov 8-K Crypto CSV Update

    .DESCRIPTION
    This script updates the SEC.gov 8-K crypto CSV file in this repo.
#>

param(
    #Storage resource name
    [Parameter(Mandatory=$true)]
    [string]$saName,

    #Storage RG name
    [Parameter(Mandatory=$true)]
    [string]$saRGName,

    #Storage table name
    [Parameter(Mandatory=$true)]
    [string]$tableName
)

#Import modules
Write-Host "`nModule Checks"
$moduleList = ("AzTable")
foreach ($module in $moduleList) {
    #Module install check
    $moduleCheck = Get-InstalledModule -Name $module
    If ($moduleCheck.name -ne $module) {
        Write-Host " - PowerShell module $($module) install running"
        Install-Module $module -AllowClobber -Force 

    } Else {
        Write-Host " - PowerShell module $($module) installed successfully"
    }

    #Module import check
    Import-Module $module
    $moduleCheck = Get-Module -Name $module -ErrorAction SilentlyContinue
    If ($null -ne $moduleCheck) {
        Write-Host " - PowerShell module $($module) installed successfully"
    } Else {
        Write-Host " - PowerShell module $($module) installed failed"
        exit
    }
 }

#Get storage resource
Write-Host "`nFetch Storage"
$saObject = Get-AzStorageAccount -Name $saName -ResourceGroupName $saRGName
If ($null -eq $saObject) {
    Write-Host " - ERROR: Storage fetch failure"
    exit 1
}
$ctx = $saObject.Context

#Get table resource
Write-Host "`nFetch Table"
$table = (Get-AzStorageTable -Name $($tableName) -Context $ctx).CloudTable
If ($null -eq $table) {
    Write-Host " - ERROR: Table fetch failure"
    exit 1
}

#Query table resource
Write-Host "`nTable Query"
$formRecords = Get-AzTableRow -table ($table) | Where-Object {$_.commit_mastodon -eq "True"} | Sort-Object -Property updated -Descending | Select-Object `
    title,
    cik,
    accession_number,
    @{Label="form";Expression={$_.category_term}},
    href,
    id,
    summary,
    updated
If ($null -eq $formRecords) {
    Write-Host " - ERROR: Table query failure"
    exit 1
}

#Update CSV
Write-Host "`nUpdate CSV"
$csvPath = "./reports/sec_8k_crypto.csv"
$formRecords | Export-Csv -Path $csvPath -Force -Verbose

#Add to repo
$time = (Get-Date).ToUniversalTime().ToString("MM/dd/yyyy HH:mm:ss")
git config --global user.email "Runner@cityhallin.com"
git config --global user.name "Runner"
git add $csvPath
git commit -m "Update CSV $($time) UTC"
git push origin HEAD:main --force