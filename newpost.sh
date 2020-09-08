#!/bin/bash

workdir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
DATE=`date '+%Y-%m-%dT%H:%M:%S%:z'`
cd $workdir
read -p "post file name: " file_name
$workdir/hugo.exe new post/${file_name}.md
echo $?
if [[ ${?} == 0 ]]; then
  echo "add markdown header"
  echo "---" >> $workdir/content/post/${file_name}.md
  echo "title: ${file_name}" >> $workdir/content/post/${file_name}.md
  echo "date: ${DATE}" >> $workdir/content/post/${file_name}.md
  echo "draft: true" >> $workdir/content/post/${file_name}.md
  echo "---" >> $workdir/content/post/${file_name}.md
fi
code $workdir/content/post/${file_name}.md
