$Commits="$(git log --format=%B -n 2)"
IFS='\n'
read -a temp <<< "$Commits"
$count=${#temp[@]}
echo "\n INFO: Last [$count] commit messages:$temp" 
for (( i=0; i <= ${#temp[@]}; i+=2)
do
$message="$temp[$i]"
if [[ "$message" == *"Merge*branch*"* ]]; then
$difffiles="$(git diff HEAD~2 HEAD~1 --name-status)"
read -a temp <<< "$difffiles"
else
$files="$(git diff HEAD~ HEAD --name-status)"
read -a temp <<< "$files"
fi
$count=${#temp[@]}
$commitRegex=[a-zA-Z0-9._]+@[a-zA-Z0-9]+\.com
if [[ "$message" =~ .*$commitRegex.* ]]; then
$mailid=${BASH_REMATCH[1]}
echo "Commit from DevPortal, Mail is $mailid"
else
$author="$(git --no-pager show -s --format='%an <%ae>' HEAD)"
$mailid="$(echo $author | cut -d "<" -f2 | cut -d ">" -f1)"
echo "Commit from Bitbucket, Mail is $mailid"
fi
echo "\n INFO: [$i] commit message: $message"
echo " INFO: [$i] Commit status: $temp"
