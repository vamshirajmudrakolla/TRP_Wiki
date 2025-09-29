# PowerShell script to fix corrupted arrow symbols in all detail pages

# Get all detail page files
$files = Get-ChildItem -Path "." -Name "detail-page*.html"

foreach ($file in $files) {
    Write-Host "Fixing arrows in $file..."
    
    # Read the file content
    $content = Get-Content -Path $file -Raw -Encoding UTF8
    
    # Replace corrupted arrow symbols with proper dropdown arrow
    $content = $content -replace 'â–¼', '▼'
    $content = $content -replace 'â–²', '▲'
    
    # Write the updated content back to the file
    Set-Content -Path $file -Value $content -Encoding UTF8
    
    Write-Host "Fixed arrows in $file"
}

Write-Host "All arrow symbols have been fixed!"