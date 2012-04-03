EXAMPLE UPGRADE PROCEDURE
=========================

First, stop the web server:

```
apache2ctl stop
```

Now move the sample_tracker folder to a different place thus retaining a 
complete copy of the old system - we don't want to scrub it just in case!

```
mv sample_tracker sample_tracker.old
```

Go to the GitHub repository where the latest copy of the application is stored
and download a copy. The URL is:

```
https://github.com/jhagon/sample_tracker
```

There is a button which you can click to download the application as a zip
file. You should have a file with a name something like this:

```
jhagon-sample_tracker-b493e1b.zip
```

Now, unzip the file (at the moment, it doesn't matter where you do this):
```
unzip jhagon-sample_tracker-b493e1b.zip
```

Now you should have a directory called something like:

```
jhagon-sample_tracker-b493e1b
```

Now go to a shell as root:

```
sudo bash
```

and move the above directory to the live application location:

```
mv jhagon-sample_tracker-b493e1b /usr/local/share
```

then go to the `/usr/local/share` directory and after checking that the
directory `sample_tracker` no longer exists (you should have moved it
earlier), rename the above directory to `sample_tracker`:

```
cd /usr/local/share
mv jhagon-sample_tracker-b493e1b sample_tracker
```

Now change to the `sample_tracker` directory and remove the production database (if it exists) and also the `public` direcory:

```
rm db/production.sqlite3
rm -rf public
```

Now we can copy the live production database we saved earlier along with the
`public` directory which contains sample data files, images etc as well as
local static content such as stylesheets.

```
cp <previous sample_tracker dir>/db/production.sqlite3 db
cp -r <previous sample_tracker dir>/public .
```

We must now migrate the database to its new schema. First we must make
sure we are running the latest ruby. The server's default version of ruby is
too old so we must instead use a special version which we can access by
typing:

```
source /etc/profile.d/rvm.sh
```

to check this, if you type `ruby -v` you should get this:

```
ruby 1.9.2p290 (2011-07-09 revision 32553) [i686-linux]
```

Now perform a database schema migration by typing the following:

```
export RAILS_ENV=production
rake db:migrate
```

Note that you may see a couple of warnings during the rake command, but
this is OK.

We are almost done. Next change the ownership of the entire `sample_tracker`
directory structure to user `nobody`:

```
chown -R nobody.root sample_tracker
```

the above command assumes you have changed to the directory which contains
the `sample_tracker` directory.

Now all that is left is to start the web server (and hope!):

```
apache2ctl start
```
