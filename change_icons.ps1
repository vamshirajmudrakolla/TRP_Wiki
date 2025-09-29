# PowerShell script to change book icons to file icons in Index.html

$filePath = "Index.html"

if (Test-Path $filePath) {
    Write-Host "Processing $filePath..."
    
    # Read the file content
    $content = Get-Content $filePath -Raw
    
    # Replace book-open class with file-text class
    $content = $content -replace 'lucide-book-open', 'lucide-file-text'
    
    # Replace the book-open SVG path with file-text SVG path
    # Book-open SVG path: <path d="M12 7v14"></path><path d="M3 18a1 1 0 0 1-1-1V4a1 1 0 0 1 1-1h5a4 4 0 0 1 4 4 4 4 0 0 1 4-4h5a1 1 0 0 1 1 1v13a1 1 0 0 1-1 1h-6a3 3 0 0 0-3 3 3 3 0 0 0-3-3z"></path>
    # File-text SVG path: <path d="M15 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V7Z"></path><path d="M14 2v4a2 2 0 0 0 2 2h4"></path><path d="M10 9H8"></path><path d="M16 13H8"></path><path d="M16 17H8"></path>
    
    $bookOpenPath = '<path d="M12 7v14"></path><path d="M3 18a1 1 0 0 1-1-1V4a1 1 0 0 1 1-1h5a4 4 0 0 1 4 4 4 4 0 0 1 4-4h5a1 1 0 0 1 1 1v13a1 1 0 0 1-1 1h-6a3 3 0 0 0-3 3 3 3 0 0 0-3-3z"></path>'
    $fileTextPath = '<path d="M15 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V7Z"></path><path d="M14 2v4a2 2 0 0 0 2 2h4"></path><path d="M10 9H8"></path><path d="M16 13H8"></path><path d="M16 17H8"></path>'
    
    $content = $content -replace [regex]::Escape($bookOpenPath), $fileTextPath
    
    # Write the updated content back to the file
    Set-Content -Path $filePath -Value $content -Encoding UTF8
    
    Write-Host "Successfully updated icons in $filePath"
} else {
    Write-Host "File $filePath not found!"
}

Write-Host "Icon replacement completed!"