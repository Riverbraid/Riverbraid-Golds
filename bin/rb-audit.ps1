echo "🔍 Riverbraid Audit..."
if (Test-Path ./verify-all.sh) { sh ./verify-all.sh }
node coupling-test.mjs
echo "✅ Audit complete."
