#Get Credentials from User
$credential = get-credential

#Export Credentials to XML for later use
$credential | Export-Clixml -Path ".\JoinDomainCred.xml"