Param()

$root = Split-Path -Parent $MyInvocation.MyCommand.Path
$pages = Get-ChildItem -Path $root -Filter 'detail-page-*.html' | Sort-Object Name

$cssBlock = @'
/* Sidebar buttons and right expandable bars */
.left-filter-buttons {
  position: fixed;
  left: 24px;
  top: 140px;
  width: 180px;
  display: flex;
  flex-direction: column;
  gap: 12px;
  z-index: 10;
}

.left-filter-buttons a {
  display: block;
  padding: 10px 12px;
  border: 2px solid #0f172a;
  border-radius: 8px;
  background: rgba(255, 255, 255, 0.12);
  color: #0f172a;
  text-decoration: none;
  font-weight: 600;
  text-align: center;
  backdrop-filter: blur(2px);
}

.left-filter-buttons a:hover {
  background: rgba(255, 255, 255, 0.22);
}

.right-expandable-bars {
  position: fixed;
  right: 24px;
  top: 140px;
  width: 220px;
  display: flex;
  flex-direction: column;
  gap: 12px;
  z-index: 10;
}

.mini-section {
  border: 2px solid #0f172a;
  border-radius: 8px;
  overflow: hidden;
  background: rgba(255, 255, 255, 0.12);
}

.mini-header {
  width: 100%;
  text-align: left;
  padding: 8px 12px;
  background: rgba(255, 255, 255, 0.12);
  cursor: pointer;
  display: flex;
  align-items: center;
  justify-content: space-between;
  font-weight: 600;
}

.mini-content {
  display: none;
  padding: 8px 12px;
}

.mini-header.expanded + .mini-content {
  display: block;
}
'@

$sidebarsHtml = @'
<aside class="left-filter-buttons">
  <a href="https://www.outlook.com" target="_blank" rel="noopener">All</a>
  <a href="https://www.outlook.com" target="_blank" rel="noopener">DOL</a>
  <a href="https://www.outlook.com" target="_blank" rel="noopener">Letters</a>
  <a href="https://www.outlook.com" target="_blank" rel="noopener">Statements</a>
</aside>

<aside class="right-expandable-bars">
  <div class="mini-section">
    <button class="mini-header">Box 1 <span class="arrow">&#9660;</span></button>
    <div class="mini-content"><p>Small expandable content.</p></div>
  </div>
  <div class="mini-section">
    <button class="mini-header">Box 2 <span class="arrow">&#9660;</span></button>
    <div class="mini-content"><p>Small expandable content.</p></div>
  </div>
  <div class="mini-section">
    <button class="mini-header">Box 3 <span class="arrow">&#9660;</span></button>
    <div class="mini-content"><p>Small expandable content.</p></div>
  </div>
</aside>
'@

$miniScript = @'
    <script>
      // Mini expandable bars on right side
      document.addEventListener(''DOMContentLoaded'', function() {
        const miniHeaders = document.querySelectorAll(''.mini-header'');
        miniHeaders.forEach(function(h) {
          h.addEventListener(''click'', function() {
            h.classList.toggle(''expanded'');
          });
        });
      });
    </script>
'@

$updatedCount = 0
foreach ($page in $pages) {
  $content = Get-Content -Path $page.FullName -Raw

  # Skip if already updated
  if ($content -match 'left-filter-buttons' -and $content -match 'right-expandable-bars') {
    continue
  }

  # Inject CSS before </style>
  if ($content -match '</style>') {
    $content = $content -replace '</style>', "$cssBlock`r`n</style>"
  }

  # Insert sidebars right after closing header div
  $content = $content -replace '(?s)(<div class="header">.*?</div>)', "$1`r`n$sidebarsHtml"

  # Append mini script before </body>
  $content = $content -replace '</body>', "$miniScript`r`n</body>"

  Set-Content -Path $page.FullName -Value $content -Encoding UTF8
  $updatedCount++
}

Write-Output "Updated $updatedCount detail pages with sidebars."