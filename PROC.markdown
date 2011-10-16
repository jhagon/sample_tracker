Basic Procedures
================

Global git setup (if necessary):
```
  git config --global user.name "J.P.Hagon"
  git config --global user.email jphagon@gmail.com
```
Create rails depot app:
```
  rails new depot -T
  cd depot
  mv README README.markdown # Edit README appropriately
```
Set up rspec:

First  add development and test groups to Gemfile, e.g.
 ``` 
  group :development do
    gem 'spec-rails'
  end
  group :test do
    gem 'rspec'
  end

  bundle install
  rails generate rspec:install
```
Change .gitignore - I use this:
```
.bundle
db/*.sqlite3
log/*.log
tmp/
doc/api
doc/app
*.swp
*~
```

Initialize github repository (you must create the repo first on github):
```
  cd depot
  git init
  git add .
  git commit -m 'first commit'
  git remote add origin git@github.com:jhagon/depot.git
  git push -u origin master
```
Install extra essential gems, namely Faker and Factory Girl:
```
group :development do
  gem 'rspec-rails'
  gem 'faker'
end

group :test do
  gem 'rspec'
  gem 'factory_girl_rails'
end
```
(Note: Faker is used to generate lots of realistic data for the development
database and Factory Girl is used to create fixture data for the test
database.)

Branching and Merging with Git
==================

To create a new branch:
```
git checkout -b <branch name>
```
Check with the 'git branch' command which shows all branches with an
asterisk to indicate which branch we're currently on. Can also use
'git status' to see what's been committed. After changes can use 'git add .'
(which we must do anyway if new files are added to the project)
but git provides the '-a' flag for committing all modifications to
existing files (including files created by 'git mv' which don't count
as new files to git):
```
git add .
git commit -m <commit string>
```
or, if you haven't created any new files, simply use:
```
git commit -a -m <commit string>
```
Now we can merge the branch back into the master if all is well. First, we
switch to the master branch:
```
git checkout master
```
and then merge the branch into the master:
```
git merge <branch name>
```
After the merge, can if desired, delete the branch:
```
git branch -d <branch name>
```
If you haven't merged the branch, it can still be deleted if required, but
you must use the '-D' option rather than '-d'.
As usual, after the merge, you can push the changes back to the master:
```
git push
```
This completes the branch,edit,commit,merge,push cycle.

Deleting a Branch
=================

Sometimes we might make a mess of a branch and need to completely scrub it.
Follow this procedure:
```
git checkout -b topic-branch
<mess up somewhere>
git add .
git commit -m -a "messed up"
git checkout master
git branch -D topic-branch
git branch -d topic-branch (optional)
```
the last line does a final cleanup and actually deletes the branch name
itself if required.
