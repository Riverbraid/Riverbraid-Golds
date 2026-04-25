$scriptPath = Split-Path -Parent $MyInvocation.MyCommand.Definition
$repoRoot = Split-Path -Parent $scriptPath
$testScript = Join-Path $repoRoot "coupling-test.mjs"

Write-Host "🔍 Riverbraid Audit..." -ForegroundColor Cyan
node $testScript
Write-Host "✅ Audit complete." -ForegroundColor Green
