$commitMsg="Sushmitha.K@mindtree.com"
$temp=$commitMsg
echo "`n INFO: Last commit messages:$commitMsg" 
$message=$commitMsg
if($message -like 'Merge*branch*')
{
$difffiles="A       helloworld/Dockerfile"
$temp=$difffiles -split [System.Environment]::NewLine
}
else
{
$files="M       helloworld/Dockerfile"
$temp=$files -split [System.Environment]::NewLine
}
$count=$temp.Length
$commitRegex="[a-zA-Z0-9._]+@[a-zA-Z0-9]+\.com"
if($message -match $commitRegex)
{
$mailid=$message | select-string -Pattern $commitRegex -AllMatches | % { $_.Matches } | % { $_.Value } | select -unique
write-host("Commmit from DevPortal, Mail is $mailid")
}
else{
$author=$(git --no-pager show -s --format='%an <%ae>' HEAD)
$mailid=$(echo $author | cut -d "<" -f2 | cut -d ">" -f1)
write-host("Commit from Bitbucket, Mail is $mailid")
}
Write-Host "`n INFO: [$i] commit message: $message"
Write-Host " INFO: [$i] Commit status: $temp"
$name=$temp
Write-Host "`n INFO: Inside FOR loop, file [$i]:$name"
$output=$name.Split("`t")
$outputFile="temp"
if ($output[0] -eq "D")
{
echo " INFO: File Status (D) Deleted, build is not required"
}
elseif (($output[0] -eq "R100") -or ($output[0] -eq "R099") -or ($output[0] -eq "R095") )
{
$outputFileinside = $output[2]
$outputFile=$outputFileinside
echo " INFO: File Status (R100,R099,R095) Rename/Move, build required"  
}
elseif (($output[0] -eq "A") -or ($output[0] -eq "M") )
{
$outputFileinside =$output[1]
$outputFile=$outputFileinside
echo " INFO: File Status (A,M) Added/Modified, build required"  
}
if ($outputFile -eq "temp")
{
echo "`n File got deleted, no build required`n"
}
else
{
echo "`n File got updated/modified, proceeding with the build"
Write-Host "Publisher Name: $author"
Write-Host "Publisher Email: $mailid"
Write-Host "Filename: $outputFile"
$author, $mailid, $outputFile -join ':' >> buildInfo.txt
} 
