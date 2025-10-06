Param()

# Apply design updates across detail-page-2.html to detail-page-32.html
$root = Split-Path -Parent $MyInvocation.MyCommand.Path
Set-Location $root

$files = Get-ChildItem -File -Filter 'detail-page-*.html' | Where-Object { $_.Name -ne 'detail-page-1.html' }

$filterButtons = @'
                <div class="filter-buttons">
                    <a class="button-17" href="https://www.gmail.com" target="_blank" rel="noopener noreferrer">All</a>
                    <a class="button-17" href="https://www.gmail.com" target="_blank" rel="noopener noreferrer">DOL</a>
                    <a class="button-17" href="https://www.gmail.com" target="_blank" rel="noopener noreferrer">Letters</a>
                    <a class="button-17" href="https://www.gmail.com" target="_blank" rel="noopener noreferrer">Statements</a>
                </div>
'@

$cssBlock = @'
        /* ---- Shared design overrides injected by script ---- */
        .content { max-width: 1100px; margin: 0 auto; }
        .main-content { border-radius: var(--radius); padding: 0.75rem 1.5rem 1.5rem 0.25rem; display: grid; grid-template-columns: 160px 1fr; gap: 0.125rem; align-items: start; }
        .filter-buttons { display: flex; flex-direction: column; gap: 0.5rem; align-items: stretch; justify-content: flex-start; width: 100%; margin-bottom: 0.5rem; margin-left: 0; grid-column: 1; }
        .filter-buttons .button-17 { width: 100%; }

        /* Button 17 full style */
        .button-17 { align-items: center; appearance: none; background-color: #fff; border-radius: 24px; border-style: none; box-shadow: rgba(0, 0, 0, .2) 0 3px 5px -1px,rgba(0, 0, 0, .14) 0 6px 10px 0,rgba(0, 0, 0, .12) 0 1px 18px 0; box-sizing: border-box; color: #3c4043; cursor: pointer; display: inline-flex; fill: currentcolor; font-family: "Google Sans",Roboto,Arial,sans-serif; font-size: 14px; font-weight: 700; height: 48px; justify-content: center; letter-spacing: .25px; line-height: normal; max-width: 100%; overflow: visible; padding: 2px 24px; position: relative; text-align: center; text-transform: none; text-decoration: none; transition: box-shadow 280ms cubic-bezier(.4, 0, .2, 1),opacity 15ms linear 30ms,transform 270ms cubic-bezier(0, 0, .2, 1) 0ms; user-select: none; -webkit-user-select: none; touch-action: manipulation; width: auto; will-change: transform,opacity; z-index: 0; }
        .button-17:hover { background: #F6F9FE; color: #174ea6; }
        .button-17:active { box-shadow: 0 4px 4px 0 rgb(60 64 67 / 30%), 0 8px 12px 6px rgb(60 64 67 / 15%); outline: none; }
        .button-17:focus { outline: none; border: 2px solid #4285f4; }
        .button-17:not(:disabled) { box-shadow: rgba(60, 64, 67, .3) 0 1px 3px 0, rgba(60, 64, 67, .15) 0 4px 8px 3px; }
        .button-17:not(:disabled):hover { box-shadow: rgba(60, 64, 67, .3) 0 2px 3px 0, rgba(60, 64, 67, .15) 0 6px 10px 4px; }
        .button-17:not(:disabled):focus { box-shadow: rgba(60, 64, 67, .3) 0 1px 3px 0, rgba(60, 64, 67, .15) 0 4px 8px 3px; }
        .button-17:not(:disabled):active { box-shadow: rgba(60, 64, 67, .3) 0 4px 4px 0, rgba(60, 64, 67, .15) 0 8px 12px 6px; }
        .button-17:disabled { box-shadow: rgba(60, 64, 67, .3) 0 1px 3px 0, rgba(60, 64, 67, .15) 0 4px 8px 3px; }

        .content-right { grid-column: 2; }
        @media (max-width: 768px) { .main-content { grid-template-columns: 1fr; } .filter-buttons { width: 100%; flex-direction: row; flex-wrap: wrap; margin-left: 0; } .filter-buttons .button-17 { flex: 1 1 auto; min-width: 120px; height: 42px; padding: 2px 18px; font-size: 13px; } .content-right { grid-column: 1; } }
        @media (max-width: 480px) { .button-17 { height: 38px; padding: 0 14px; font-size: 12px; } }
        /* ---- End shared design overrides ---- */
'@

foreach ($file in $files) {
  $text = Get-Content -Raw -Path $file.FullName

  # Inject or replace CSS overrides inside the <style> block
  $pattern = '(?s)/\* ---- Shared design overrides injected by script ---- \*/.*?/\* ---- End shared design overrides ---- \*/'
  if ($text -match $pattern) {
    $text = [regex]::Replace($text, $pattern, $cssBlock)
  } else {
    $text = $text -replace '(</style>)', "$cssBlock`n`$1"
  }

  # Insert filter buttons and wrap right content in .content-right
  if ($text -notmatch '<div class="filter-buttons">') {
    $text = $text -replace '<div class="main-content">', "<div class=`"main-content`">`r`n$filterButtons`r`n                <div class=`"content-right`">"
  }

  # Close .content-right before main-content closes
  if ($text -match '</div>\s*</div>\s*</div>\s*</div>') {
    # Try to insert before the closing of main-content block
    $text = $text -replace '(\s*</div>\s*</div>\s*</div>\s*</div>\s*)', "`r`n                </div>`r`n            `$1"
  } elseif ($text -match '</div>\s*</div>\s*</div>') {
    $text = $text -replace '(\s*</div>\s*</div>\s*</div>\s*)', "`r`n                </div>`r`n            `$1"
  }

  Set-Content -Path $file.FullName -Value $text -Encoding UTF8
}

Write-Host "Applied design updates to $($files.Count) pages." -ForegroundColor Green