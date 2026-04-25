$ErrorActionPreference = "Stop"
Write-Host "--- Riverbraid Global Audit Start ---" -ForegroundColor Cyan

$ParentDir = Split-Path -Parent $PSScriptRoot
$Repos = Get-ChildItem -Path $ParentDir -Directory | Where-Object { $_.Name -like "Riverbraid-*" -or $_.Name -eq "riverbraid-tsh" }

foreach ($Repo in $Repos) {
    Write-Host "Verifying: $($Repo.Name)" -NoNewline
    cd $Repo.FullName
    if (Test-Path ".anchor") {
        $status = git status --porcelain
        if ($status) {
            Write-Host " [DRIFT DETECTED]" -ForegroundColor Red
        } else {
            Write-Host " [STATIONARY]" -ForegroundColor Green
        }
    } else {
        Write-Host " [NO ANCHOR FOUND]" -ForegroundColor Yellow
    }
}
Write-Host "--- Audit Complete ---" -ForegroundColor Cyan
