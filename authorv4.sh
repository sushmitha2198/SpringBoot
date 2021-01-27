set -x
Commits="$(git log --format=%B -n 2)"
IFS=$'\n' temp=($Commits)
count=${#temp[@]}
echo "\n [INFO] Last [$count] commit messages:'${temp[*]}'" 
for (( i=0; i < ${#temp[@]}; i+=2 ))
do
message="${temp[$i]}"
if [[ "$message" == *"Merge*branch*"* ]]; then
difffiles="$(git diff HEAD~2 HEAD~1 --name-status)"
IFS=$'\n' temp=($difffiles)
else
files="$(git diff HEAD~ HEAD --name-status)"
IFS=$'\n' temp=($files)
fi
commitRegex=[a-zA-Z0-9._]+\@+[a-zA-Z0-9]+\.com
if [[ $message =~ $commitRegex ]]; then
mailid=$(echo "$message"|grep -P "$commitRegex" -o)
echo "Commit from DevPortal, Mail is $mailid"
else
author="$(git --no-pager show -s --format='%an <%ae>' HEAD)"
mailid="$(echo $author | cut -d "<" -f2 | cut -d ">" -f1)"
echo "Commit from Bitbucket, Mail is $mailid"
fi
echo "\n[INFO] [$i] commit message: $message"
echo "[INFO] [$i] Commit status: $temp"
for (( i=0; i < ${#temp[@]}; i+=2 ))
do
name=${temp[$i]}
echo "\n[INFO] Inside FOR loop, file [$i]:$name"
IFS=$'\t' output=($name)
echo "${output[*]}"
outputFile="temp"
if [[ ${output[0]} == "D" ]]; then
echo "[INFO] File Status (D) Deleted, build is not required"
elif [[ "${output[0]}" == "R100" || "${output[0]}" == "R099" || "${output[0]}" == "R095" ]]; then
outputFileinside= "${output[2]}"
outputFile="$outputFileinside"
echo "[INFO] File Status (R100,R099,R095) Rename/Move, build required"  
elif [[ "${output[0]}" == "A" || "${output[0]}" == "M" ]]; then
outputFileinside="${output[1]}"
outputFile="$outputFileinside"
echo "[INFO] File Status (A,M) Added/Modified, build required"  
fi
if [[ "$outputFile" == "temp" ]]; then
echo "\n File got deleted, no build required\n"
else
echo "\n File got updated/modified, proceeding with the build"
echo "Publisher Name: $author"
echo "Publisher Email: $mailid"
echo "Filename: $outputFile" 
echo "$author:$mailid:$outputFile" >> buildInfo.txt
#$author, $mailid, $outputFile -join ':' >> buildInfo.txt
fi
done
done