set workdir=%~dp0
set current=%date:~0,4%-%date:~5,2%-%date:~8,2% %time:~0,2%:%time:~3,2%:%time:~6,2%
cd %workdir%
git add -A
git commit -m "Hugo update %current%"
git push -u origin master
.\hugo.exe --buildDrafts
cd public
git add .
git commit -m "Blog update %current%"
git push origin master
PAUSE
EXIT
