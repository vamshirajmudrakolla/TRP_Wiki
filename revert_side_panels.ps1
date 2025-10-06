Param()

$root = Split-Path -Parent $MyInvocation.MyCommand.Path

function Revert-File($path) {
  $content = Get-Content -Path $path -Raw

  # Remove CSS override block
  $content = [Regex]::Replace($content, '(?s)/\* === SIDEPANELS OVERRIDE START === \*/.*?/\* === SIDEPANELS OVERRIDE END === \*/', '')

  # Remove original side panel CSS block
  $content = [Regex]::Replace($content, '(?s)/\* Sidebar buttons and right expandable bars \*/.*?\.mini-header\.expanded \+ \.mini-content \{\s*display:\s*block;\s*\}\s*', '')

  # Remove left and right aside blocks
  $content = [Regex]::Replace($content, '(?s)<aside class="left-filter-buttons">.*?</aside>\s*', '')
  $content = [Regex]::Replace($content, '(?s)<aside class="right-expandable-bars">.*?</aside>\s*', '')

  # Remove mini JS block
  $content = [Regex]::Replace($content, '(?s)<!-- === MINI SIDEPANELS JS START === -->.*?<!-- === MINI SIDEPANELS JS END === -->', '')

  # Remove any stray PowerShell-injected text blocks
  $content = [Regex]::Replace($content, '(?s)\s*param\(\$m\).*?return\s+\$block\s*', '')

  Set-Content -Path $path -Value $content -Encoding UTF8
}

$pages = Get-ChildItem -Path $root -Filter 'detail-page-*.html' | Sort-Object Name
$count = 0
foreach ($page in $pages) {
  Revert-File $page.FullName
  $count++
}

# Also revert template and any base detail-page.html if present
$templates = @('detail-page-template.html','detail-page.html') | ForEach-Object { Join-Path $root $_ } | Where-Object { Test-Path $_ }
foreach ($t in $templates) { Revert-File $t }

Write-Output "Reverted side panels and styles on $count pages and updated templates."