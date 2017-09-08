e:
cd \hugo\blog
git add .
git commit -m "first commit"
git push -u origin master
hugo --buildDrafts
cd public
git add .
git commit -m "Generate site"
git push origin master