Param()

$root = Split-Path -Parent $MyInvocation.MyCommand.Path
$pages = Get-ChildItem -Path $root -Filter 'detail-page-*.html'

$fixed = 0
foreach ($page in $pages) {
  $content = Get-Content -Path $page.FullName -Raw
  if ($content -match 'Mini expandable bars on right side') {
    $content = $content -replace '(?s)(<script>\s*// Mini expandable bars on right side.*?</script>)', {
      param($m)
      $block = $m.Value
      $block = $block -replace "''", "'"
      return $block
    }
    Set-Content -Path $page.FullName -Value $content -Encoding UTF8
    $fixed++
  }
}

Write-Output "Fixed quotes in $fixed pages."