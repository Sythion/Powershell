Clear-Host
Get-ChildItem -Path "C:\champsgoldthree\ChampsGoldThree\" -Recurse | Select-String 'text message received from' | select path -Unique 