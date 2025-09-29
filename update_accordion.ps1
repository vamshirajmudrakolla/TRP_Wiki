# PowerShell script to update all detail pages with reduced bar height and accordion behavior

# Get all detail page files
$files = Get-ChildItem -Path "." -Name "detail-page*.html"

foreach ($file in $files) {
    Write-Host "Processing $file..."
    
    # Read the file content
    $content = Get-Content -Path $file -Raw
    
    # Update the expandable header padding (reduce height further)
    $content = $content -replace 'padding: 0\.5rem 1rem;', 'padding: 0.25rem 1rem;'
    
    # Update the JavaScript to implement accordion behavior
    $oldScript = @"
    <script>
        document.addEventListener('DOMContentLoaded', function() {
            // Handle expandable sections
            const expandableSections = document.querySelectorAll('.expandable-header');
            
            expandableSections.forEach(section => {
                section.addEventListener('click', function() {
                    this.classList.toggle('expanded');
                    const content = this.nextElementSibling;
                    content.classList.toggle('expanded');
                });
            });
            
            // Expand the first section by default
            if (expandableSections.length > 0) {
                expandableSections[0].click();
            }
        });
    </script>
"@

    $newScript = @"
    <script>
        document.addEventListener('DOMContentLoaded', function() {
            // Handle expandable sections with accordion behavior
            const expandableSections = document.querySelectorAll('.expandable-header');
            
            expandableSections.forEach(section => {
                section.addEventListener('click', function() {
                    // Close all other sections first
                    expandableSections.forEach(otherSection => {
                        if (otherSection !== this) {
                            otherSection.classList.remove('expanded');
                            const otherContent = otherSection.nextElementSibling;
                            otherContent.classList.remove('expanded');
                        }
                    });
                    
                    // Toggle the clicked section
                    this.classList.toggle('expanded');
                    const content = this.nextElementSibling;
                    content.classList.toggle('expanded');
                });
            });
            
            // Expand the first section by default
            if (expandableSections.length > 0) {
                expandableSections[0].click();
            }
        });
    </script>
"@

    # Replace the script section
    $content = $content -replace [regex]::Escape($oldScript), $newScript
    
    # Write the updated content back to the file
    Set-Content -Path $file -Value $content -Encoding UTF8
    
    Write-Host "Updated $file"
}

Write-Host "All detail pages have been updated with reduced bar height and accordion behavior!"