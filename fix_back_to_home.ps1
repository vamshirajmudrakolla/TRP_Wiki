# PowerShell script to update 'Back to Home' links to Index.html across detail pages
$folder = "."
$patternFiles = @(
    "detail-page-*.html",
    "detail-page.html",
    "detail-page-template.html"
)

Write-Host "Updating Back to Home links to point to ./Index.html"

foreach ($glob in $patternFiles) {
    Get-ChildItem -Path $folder -Filter $glob | ForEach-Object {
        $path = $_.FullName
        $content = Get-Content -Path $path -Raw -Encoding UTF8

        # Replace explicit Emergent page href with Index.html
        $content = $content -replace 'href="\./Emergent _ Fullstack App\.html"', 'href="./Index.html"'
        $content = $content -replace "href='\./Emergent _ Fullstack App\.html'", "href='./Index.html'"

        # More robust: any href containing Emergent _ Fullstack App.html
        $content = $content -replace 'href="[^"]*Emergent _ Fullstack App\.html"', 'href="./Index.html"'
        $content = $content -replace "href='[^']*Emergent _ Fullstack App\.html'", "href='./Index.html'"

        # Ensure Back to Home anchors without href get Index.html (fallback)
        $content = $content -replace '(?<anchor><a[^>]*class="[^"]*back-button[^"]*"[^>]*)(?!href=)([^>]*)>', '${anchor} href="./Index.html">'

        Set-Content -Path $path -Value $content -Encoding UTF8
        Write-Host "Updated: $path"
    }
}

Write-Host "All Back to Home links now point to ./Index.html"