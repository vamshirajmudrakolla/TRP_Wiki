# PowerShell script to change all icons to PDF icons in Index.html
$filePath = "Index.html"

if (Test-Path $filePath) {
    Write-Host "Processing $filePath..."
    
    # Read the file content
    $content = Get-Content $filePath -Raw -Encoding UTF8
    
    # Replace lucide-file-text class with lucide-file-type (PDF icon)
    $content = $content -replace 'lucide-file-text', 'lucide-file-type'
    
    # Replace the SVG path for file-text icon with PDF icon path
    # Current file-text path: M15 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V7Z + M14 2v4a2 2 0 0 0 2 2h4 + lines
    # PDF icon path: M15 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V7Z + M14 2v4a2 2 0 0 0 2 2h4 + PDF text
    
    # Replace the file-text SVG paths with PDF icon paths
    $oldPath = '<path d="M15 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V7Z"></path><path d="M14 2v4a2 2 0 0 0 2 2h4"></path><path d="M10 9H8"></path><path d="M16 13H8"></path><path d="M16 17H8"></path>'
    $newPath = '<path d="M15 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V7Z"></path><path d="M14 2v4a2 2 0 0 0 2 2h4"></path><path d="M8 11h2v2H8z"></path><path d="M14 11h2v2h-2z"></path><path d="M8 15h6v1H8z"></path>'
    
    $content = $content -replace [regex]::Escape($oldPath), $newPath
    
    # Also replace any remaining generic file paths with PDF-specific styling
    # Add PDF text indicator in the icon
    $content = $content -replace 'class="lucide lucide-file-type', 'class="lucide lucide-file-type pdf-icon'
    
    # Write the updated content back to the file
    Set-Content $filePath -Value $content -Encoding UTF8
    
    Write-Host "Successfully updated icons to PDF icons in $filePath"
} else {
    Write-Host "File $filePath not found!"
}

Write-Host "PDF icon replacement completed!"