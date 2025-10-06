Param()

$root = Split-Path -Parent $MyInvocation.MyCommand.Path
$files = Get-ChildItem -Path $root -Filter 'detail-page-*.html' | Sort-Object Name

function Ensure-Header($content) {
  if ($content -match '<div\s+class="header"') { return $content }

  # Extract a reasonable title for the H1 from the <title> tag
  $h1 = 'Details'
  $m = [Regex]::Match($content, '<title>\s*([^<]+)\s*</title>', 'IgnoreCase')
  if ($m.Success) {
    $t = $m.Groups[1].Value.Trim()
    # Remove suffix like "| Emergent"
    $h1 = ($t -replace '\s*\|.*$', '').Trim()
    if ([string]::IsNullOrWhiteSpace($h1)) { $h1 = 'Details' }
  }

  $headerBlock = @"
        <div class="header">
            <h1>$h1</h1>
            <a href="./Index.html" class="back-button">Back to Home</a>
        </div>
"@

  # Insert header immediately inside the container, before the content div
  if ($content -match '<div\s+class="container"\s*>') {
    $content = $content -replace '(<div\s+class="container"\s*>)', "$1`n$headerBlock"
  } else {
    # Fallback: prepend before first .content
    $content = $content -replace '(<div\s+class="content"\s*>)', "$headerBlock`n$1"
  }
  return $content
}

function Ensure-BackLink($content) {
  # Point any back-button anchors to Index.html
  $content = $content -replace 'href="\./Emergent _ Fullstack App\.html"', 'href="./Index.html"'
  $content = $content -replace 'href="[^"#]*Index\.html"', 'href="./Index.html"'
  # If a back-button anchor exists without href, add one
  $content = [Regex]::Replace($content, '(?<anchor><a[^>]*class="[^"]*back-button[^"]*"[^>]*)(?!href=)([^>]*)>', '${anchor} href="./Index.html">')
  return $content
}

$updated = 0
foreach ($f in $files) {
  $content = Get-Content -Path $f.FullName -Raw -Encoding UTF8
  $content = Ensure-Header $content
  $content = Ensure-BackLink $content
  Set-Content -Path $f.FullName -Value $content -Encoding UTF8
  $updated++
}

# Also apply to template and base page if present
$extra = @('detail-page-template.html','detail-page.html') | ForEach-Object { Join-Path $root $_ } | Where-Object { Test-Path $_ }
foreach ($p in $extra) {
  $content = Get-Content -Path $p -Raw -Encoding UTF8
  $content = Ensure-Header $content
  $content = Ensure-BackLink $content
  Set-Content -Path $p -Value $content -Encoding UTF8
}

Write-Output "Restored header and Back to Home on $updated detail pages and templates."