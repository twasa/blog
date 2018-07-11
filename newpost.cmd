set workdir=%~dp0
cd %workdir%
set /p post="post file name: "
hugo new post/%post%.md
PAUSE
EXIT
