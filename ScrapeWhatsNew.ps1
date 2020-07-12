class WhatsNewItem {
    [string] $Date
    [string] $Change
}

$list = [System.Collections.Generic.List[WhatsNewItem]]::new()
[xml]$whatsnew = get-content 'C:\champsgoldthree\champsgoldthree\champsgui\views\WhatsNewView.xaml'

foreach($element in $whatsnew.Page.ScrollViewer.StackPanel.FlowDocumentScrollViewer.FlowDocument.Paragraph){
    [datetime]$date = New-Object datetime
    if([datetime]::TryParse($element.Bold, [ref]$date)){

        #only grab changes from last year
        if ($date.Date -gt [datetime]::Today.AddYears(-1)){

            foreach($desc in $element.NextSibling.ListItem.Paragraph)
            {
                if ($desc -is [System.Xml.XmlElement]){
                    if ($desc.Value -ne $null){
                        $trimDesc = $desc.Value.Trim()
                    }
                }
                else{
                    $trimDesc = $desc.Trim()
                }
                $trimDesc -replace '\s+', ' '
                $newRec = [WhatsNewItem] @{ Date = $date.ToString('d'); Change = $trimDesc }
                $list.Add($newRec)
            }
        }
        #$item = $element.NextSibling.ListItem.Paragraph
    }
}

$list | Export-Csv 'c:\ApplicationChanges.csv' -Delimiter "|"

# After file is created, in Excel, use Data -> Import Text/CSV.  Do not just open it and save it as Excel format.  I noticed this loses some data.