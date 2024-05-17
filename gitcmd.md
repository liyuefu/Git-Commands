# not connect to github website, just work locally.
# the source code directory will be  project -> src .
there are 3 bash files in this directory now.
the object is to put them under git management.
# steps bellow
## cd project/src
## git init 
this cmd will create .git directory under src .
## git status
should show no files.
## git add .
add 3 files to staging. 
next need to be committed.
## git status
shows 3 files in staging.
## git commit -m 'initial version'
commit 3 files.
## git status
show no files need to be commited.
## vi readme.md
create a readme.md files
## git status
shows readme.md is untracked.
## git add readme.md
or just git add .
## git status
shows readme.md can be committed.
## git commit -m 'added readme.md'

## vi readme.txt 
add one line "new line"
## git status
shows readme.md is changed.
## git diff
show the difference between old and new version.

## git restore 
restore the old version(with new line)

## git log
check all the commits.
git log --oneline
show simple one line comments
git log -p
git help log(get more help of log)
## git branch bugfix
git branch to check all the branches
git switch bugfix , switch to another bransh.
