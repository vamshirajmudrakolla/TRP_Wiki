# PowerShell script to update all detail pages
$files = @(
    "detail-page-3.html", "detail-page-4.html", "detail-page-5.html", "detail-page-6.html", "detail-page-7.html",
    "detail-page-8.html", "detail-page-9.html", "detail-page-10.html", "detail-page-11.html", "detail-page-12.html",
    "detail-page-13.html", "detail-page-14.html", "detail-page-15.html", "detail-page-16.html", "detail-page-17.html",
    "detail-page-18.html", "detail-page-19.html", "detail-page-20.html", "detail-page-21.html", "detail-page-22.html",
    "detail-page-23.html", "detail-page-24.html", "detail-page-25.html", "detail-page-26.html", "detail-page-27.html",
    "detail-page-28.html", "detail-page-29.html", "detail-page-30.html", "detail-page-31.html", "detail-page-32.html",
    "detail-page.html", "detail-page-template.html"
)

foreach ($file in $files) {
    Write-Host "Processing $file..."
    
    # Read the file content
    $content = Get-Content $file -Raw
    
    # Remove border from main-content
    $content = $content -replace 'border: 1px solid hsl\(var\(--border\)\);', ''
    
    # Reduce expandable header padding
    $content = $content -replace 'padding: 1rem;', 'padding: 0.5rem 1rem;'
    
    # Write back to file
    Set-Content -Path $file -Value $content -NoNewline
    
    Write-Host "Updated $file"
}

Write-Host "All files updated successfully!"