# PowerShell script to fix corrupted arrow symbols using HTML entities

# Get all detail page files
$files = Get-ChildItem -Path "." -Name "detail-page*.html"

foreach ($file in $files) {
    Write-Host "Fixing arrows in $file..."
    
    # Read the file content
    $content = Get-Content -Path $file -Raw -Encoding UTF8
    
    # Replace corrupted arrow symbols with HTML entities
    $content = $content -replace 'â–¼', '&#9660;'  # Down arrow HTML entity
    $content = $content -replace 'â–²', '&#9650;'  # Up arrow HTML entity
    $content = $content -replace '▼', '&#9660;'   # Also replace any existing Unicode arrows
    $content = $content -replace '▲', '&#9650;'   # Also replace any existing Unicode arrows
    
    # Write the updated content back to the file
    Set-Content -Path $file -Value $content -Encoding UTF8
    
    Write-Host "Fixed arrows in $file"
}

Write-Host "All arrow symbols have been fixed with HTML entities!"