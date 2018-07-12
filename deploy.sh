#!/bin/bash
workdir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd $workdir
git add -A
git commit -m "Hugo content update `date`"
./hugo.exe --buildDrafts
cd public
git add -A
git commit -m "Blog update `date`"
git push origin master

