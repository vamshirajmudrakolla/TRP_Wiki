# PowerShell script to replace book-open icons with file-type icons in bundle.js
$bundlePath = ".\Emergent _ Fullstack App_files\bundle.js"

Write-Host "Processing $bundlePath..."

# Read the file content
$content = Get-Content -Path $bundlePath -Raw -Encoding UTF8

# Replace book-open imports with file-type imports
$content = $content -replace 'book-open\.js', 'file-type.js'
$content = $content -replace 'book-open', 'file-type'
$content = $content -replace 'BookOpen', 'FileType'

# Write the updated content back to the file
Set-Content -Path $bundlePath -Value $content -Encoding UTF8

Write-Host "Successfully updated bundle.js with file-type icons!"