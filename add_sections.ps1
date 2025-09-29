# PowerShell script to add expandable sections to all detail pages
$files = @(
    "detail-page-3.html", "detail-page-4.html", "detail-page-5.html", "detail-page-6.html", "detail-page-7.html",
    "detail-page-8.html", "detail-page-9.html", "detail-page-10.html", "detail-page-11.html", "detail-page-12.html",
    "detail-page-13.html", "detail-page-14.html", "detail-page-15.html", "detail-page-16.html", "detail-page-17.html",
    "detail-page-18.html", "detail-page-19.html", "detail-page-20.html", "detail-page-21.html", "detail-page-22.html",
    "detail-page-23.html", "detail-page-24.html", "detail-page-25.html", "detail-page-26.html", "detail-page-27.html",
    "detail-page-28.html", "detail-page-29.html", "detail-page-30.html", "detail-page-31.html", "detail-page-32.html",
    "detail-page.html", "detail-page-template.html"
)

$newSections = @'
                
                <div class="expandable-section">
                    <div class="expandable-header">
                        Technical Specifications <span class="arrow">▼</span>
                    </div>
                    <div class="expandable-content">
                        <ul class="benefits-list">
                            <li>Advanced processing algorithms for optimal performance</li>
                            <li>Multi-threaded architecture for faster execution</li>
                            <li>Cross-platform compatibility (Windows, Mac, Linux)</li>
                            <li>Cloud-based processing with local fallback options</li>
                            <li>Real-time progress monitoring and status updates</li>
                        </ul>
                    </div>
                </div>
                
                <div class="expandable-section">
                    <div class="expandable-header">
                        System Requirements <span class="arrow">▼</span>
                    </div>
                    <div class="expandable-content">
                        <ul class="benefits-list">
                            <li>Operating System: Windows 10+, macOS 10.14+, Ubuntu 18.04+</li>
                            <li>Memory: Minimum 4GB RAM (8GB recommended)</li>
                            <li>Storage: 2GB available disk space</li>
                            <li>Network: Internet connection for cloud features</li>
                            <li>Browser: Chrome 90+, Firefox 88+, Safari 14+, Edge 90+</li>
                        </ul>
                    </div>
                </div>
                
                <div class="expandable-section">
                    <div class="expandable-header">
                        Security & Privacy <span class="arrow">▼</span>
                    </div>
                    <div class="expandable-content">
                        <ul class="benefits-list">
                            <li>End-to-end encryption for all data transfers</li>
                            <li>GDPR and CCPA compliant data handling</li>
                            <li>No permanent storage of user documents</li>
                            <li>Regular security audits and penetration testing</li>
                            <li>SOC 2 Type II certified infrastructure</li>
                        </ul>
                    </div>
                </div>
                
                <div class="expandable-section">
                    <div class="expandable-header">
                        Integration & API <span class="arrow">▼</span>
                    </div>
                    <div class="expandable-content">
                        <ul class="benefits-list">
                            <li>RESTful API with comprehensive documentation</li>
                            <li>Webhook support for real-time notifications</li>
                            <li>SDK available for popular programming languages</li>
                            <li>Direct integration with cloud storage providers</li>
                            <li>Enterprise SSO and user management systems</li>
                        </ul>
                    </div>
                </div>
                
                <div class="expandable-section">
                    <div class="expandable-header">
                        Support & Training <span class="arrow">▼</span>
                    </div>
                    <div class="expandable-content">
                        <ul class="benefits-list">
                            <li>24/7 customer support via chat, email, and phone</li>
                            <li>Comprehensive documentation and video tutorials</li>
                            <li>Live training sessions and webinars</li>
                            <li>Dedicated account manager for enterprise clients</li>
                            <li>Community forum and knowledge base</li>
                        </ul>
                    </div>
                </div>
'@

foreach ($file in $files) {
    Write-Host "Processing $file..."
    
    # Read the file content
    $content = Get-Content $file -Raw
    
    # Find the last expandable section and add new sections after it
    $pattern = '(\s*</div>\s*</div>\s*\n\s*<p>.*?</p>)'
    $replacement = $newSections + "`n`n                `$1"
    
    $content = $content -replace $pattern, $replacement
    
    # Write back to file
    Set-Content -Path $file -Value $content -NoNewline
    
    Write-Host "Updated $file with additional sections"
}

Write-Host "All files updated with new expandable sections!"