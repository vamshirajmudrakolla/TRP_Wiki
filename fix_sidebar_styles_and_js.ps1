Param()

$root = Split-Path -Parent $MyInvocation.MyCommand.Path
$pages = Get-ChildItem -Path $root -Filter 'detail-page-*.html' | Sort-Object Name

$cssOverride = @'
/* === SIDEPANELS OVERRIDE START === */
/* Layout grid to prevent overlap */
.container {
  display: grid;
  grid-template-columns: 220px 1fr 260px;
  grid-auto-rows: min-content;
  gap: 16px;
}
.header { grid-column: 1 / -1; }
.content { grid-column: 2; }

/* Sidebar buttons and right expandable bars */
.left-filter-buttons {
  width: 180px;
  display: flex;
  flex-direction: column;
  gap: 12px;
  grid-column: 1;
  align-self: start;
  position: sticky;
  top: 24px;
}

.left-filter-buttons a {
  display: block;
  padding: 12px 14px;
  border: 1px solid hsl(var(--border));
  border-radius: 10px;
  background: #ffffff;
  color: hsl(var(--foreground));
  text-decoration: none;
  font-weight: 600;
  text-align: center;
  box-shadow: 0 4px 10px rgba(0,0,0,0.08);
  transition: transform 0.15s ease, box-shadow 0.15s ease;
}

.left-filter-buttons a:hover {
  transform: translateY(-1px);
  box-shadow: 0 6px 14px rgba(0,0,0,0.12);
}

.right-expandable-bars {
  width: 220px;
  display: flex;
  flex-direction: column;
  gap: 12px;
  grid-column: 3;
  align-self: start;
  position: sticky;
  top: 24px;
}

.mini-section {
  border: 1px solid hsl(var(--border));
  border-radius: var(--radius);
  overflow: hidden;
  background: #ffffff;
}

.mini-header {
  width: 100%;
  text-align: left;
  padding: 0.25rem 1rem;
  background-color: hsl(var(--secondary));
  cursor: pointer;
  display: flex;
  align-items: center;
  justify-content: space-between;
  font-weight: 500;
}

.mini-content {
  display: none;
  padding: 0.25rem 1rem;
}

.mini-header .arrow { transition: transform 0.2s ease; }
.mini-header.expanded .arrow { transform: rotate(180deg); }
.mini-header.expanded + .mini-content { display: block; }

/* Mobile-friendly layout */
@media (max-width: 1024px) {
  .container { grid-template-columns: 1fr; }
  .content, .left-filter-buttons, .right-expandable-bars, .header {
    grid-column: 1;
    position: static;
  }
  .left-filter-buttons {
    flex-direction: row;
    flex-wrap: wrap;
    gap: 10px;
    margin-bottom: 1rem;
    width: 100%;
  }
  .left-filter-buttons a { flex: 1 1 calc(50% - 10px); }
  .right-expandable-bars { margin-bottom: 1rem; width: 100%; }
}
/* === SIDEPANELS OVERRIDE END === */
'@

$miniJs = @'
<!-- === MINI SIDEPANELS JS START === -->
<script>
  document.addEventListener('DOMContentLoaded', function() {
    var miniHeaders = document.querySelectorAll('.mini-header');
    miniHeaders.forEach(function(h){
      h.addEventListener('click', function(){
        this.classList.toggle('expanded');
        var c = this.nextElementSibling;
        if (c) c.style.display = this.classList.contains('expanded') ? 'block' : 'none';
      });
    });
  });
</script>
<!-- === MINI SIDEPANELS JS END === -->
'@

$updated = 0
foreach ($page in $pages) {
  $content = Get-Content -Path $page.FullName -Raw

  # Remove any accidental PowerShell injection leftovers
  $content = [Regex]::Replace($content, '(?s)\s*param\(\$m\).*?return\s+\$block\s*', '')

  # Insert or replace CSS override before </style>
  if ($content -match '=== SIDEPANELS OVERRIDE START ===') {
    $content = $content -replace '(?s)/\* === SIDEPANELS OVERRIDE START === \*/.*?/\* === SIDEPANELS OVERRIDE END === \*/', $cssOverride
  } else {
    $content = $content -replace '</style>', "$cssOverride`n</style>"
  }

  # Ensure mini JS exists right before </body>
  if ($content -notmatch '=== MINI SIDEPANELS JS START ===') {
    $content = $content -replace '</body>', "$miniJs`n</body>"
  }

  Set-Content -Path $page.FullName -Value $content -Encoding UTF8
  $updated++
}

Write-Output "Applied sidebar CSS/JS overrides and cleanup on $updated pages."