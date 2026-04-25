$ErrorActionPreference = "Stop"
Write-Host "--- Riverbraid Global Audit Start ---" -ForegroundColor Cyan

# Explicitly target the Michael directory where the cluster resides
$ClusterRoot = "C:\Users\theti\Desktop\Michael"
$Repos = Get-ChildItem -Path $ClusterRoot -Directory | Where-Object { $_.Name -like "Riverbraid-*" -or $_.Name -eq "riverbraid-tsh" }

foreach ($Repo in $Repos) {
    Write-Host ("Verifying: {0,-35}" -f $Repo.Name) -NoNewline
    cd $Repo.FullName
    
    if (Test-Path ".anchor") {
        $status = git status --porcelain
        if ($status) {
            Write-Host "[DRIFT DETECTED]" -ForegroundColor Red
        } else {
            Write-Host "[STATIONARY]" -ForegroundColor Green
        }
    } else {
        Write-Host "[NO ANCHOR]" -ForegroundColor Yellow
    }
}
Write-Host "--- Audit Complete ---" -ForegroundColor Cyan
