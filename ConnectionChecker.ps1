#Create SMTP Function
function Send-SMTPmail($to, $from, $subject, $body, $attachment, $cc, $bcc, $port, $timeout, $smtpserver, [switch] $html, [switch] $alert) {
	if ($smtpserver -eq $null) {$smtpserver = "CIMMAIL2"}
	$mailer = new-object Net.Mail.SMTPclient($smtpserver)
	if ($port -ne $null) {$mailer.port = $port}
	if ($timeout -ne $null) {$mailer.timeout = $timeout}
	$msg = new-object Net.Mail.MailMessage($from,$to,$subject,$body)
	if ($html) {$msg.IsBodyHTML = $true}
	if ($cc -ne $null) {$msg.cc.add($cc)}
	if ($bcc -ne $null) {$msg.bcc.add($bcc)}
	if ($alert) {$msg.Headers.Add("message-id", "<3bd50098e401463aa228377848493927-1>")}
	if ($attachment -ne $null) {
	$attachment = new-object Net.Mail.Attachment($attachment)
	$msg.attachments.add($attachment)
	}
	$mailer.send($msg)
}


$noConnectionArray = @()

(get-content c:\Scripts\ConnectionChecker\computerlist.txt) -split '\r\n' | 
% { 
    $split = $_ -split ' '
    if((Test-Connection $split[0] -Quiet) -eq $false)
    {
        $noConnectionArray += $split[1..($split.Length-1)] -join ' '
    }
}

if ($noConnectionArray.Length -gt 0)
{
    $To = 'dmccormick@champmove.com'
    $From = 'supervisor@champmove.com'
    $CC = 'jrae@champmove.com;colton@champmove.com'
    $Title = 'There are PCs that need started'
    $Body = "The following PCs need started: `n" + ($noConnectionArray -join "`n")

    Send-SMTPmail -to $To -from $From -cc $CC -subject $Title -body $Body
}

Send-SMTPmail -to 'jrae@champmove.com' -from 'supervisor@champmove.com' -subject 'ConnectionChecker Task Ran Successfully' -body 'ConnectionChecker Task Ran Successfully'

exit
