Deployment Notes for Rails3
===========================

In this document, we describe the steps taken to deploy the sample_tracker
application. First, install the web server - we're on Ubuntu 10.03 (Lucid)
and will install the apache web server. Initially we installed the following
packages via synaptic:

```
apache2-mpm-prefork
apache2.2-common
apache2.2-bin
```

After this, install Phusion Passenger:

```
sudo gem install passenger
sudo passenger-install-apache2-module
```

the passenger-install-apache2-module command will tell you what additional
packages may need to be installed. After this, you need to add the following
to the apache config file. To find out where the config file is type:

```
apache2ctl -V | grep SERVER_CONFIG_FILE
```
and add the following to the config file:

```
LoadModule passenger_module /usr/local/rvm/gems/ruby-1.9.2-p180/gems/passenger-3.0.9/ext/apache2/mod_passenger.so
PassengerRoot /usr/local/rvm/gems/ruby-1.9.2-p180/gems/passenger-3.0.9
PassengerRuby /usr/local/rvm/wrappers/ruby-1.9.2-p180/ruby
```
Suppose you have a Rails application in /somewhere. Add a virtual host to your
Apache configuration file and set its DocumentRoot to /somewhere/public:

```
   <VirtualHost *:80>
      ServerName www.yourhost.com
      DocumentRoot /somewhere/public    # <-- be sure to point to 'public'!
      <Directory /somewhere/public>
         AllowOverride all              # <-- relax Apache security settings
         Options -MultiViews            # <-- MultiViews must be turned off
      </Directory>
   </VirtualHost>
```

Also, need to do a full deployment bundle install to be safe:

```
bundle install --deployment
```

Mailer config
=============

Add this line to config/environments/production.rb:

```
  # standard mailer setup
  config.action_mailer.delivery_method = :sendmail
```

Database Migration
==================

To initialize a brand new production database:

```
rake db:setup RAILS_ENV="production"
```

To apply migrations to a production database:

```
export RAILS_ENV=production
rake db:migrate
```

May need (for completeness) to add humanized references to new fields in sample model file.

NOW SOMETHING VERY IMPORTANT!!!
===============================

Remember to always save not only the database, but the public folder as well in the production database because this contains sample images and other files.


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

Now change to the `sample_tracker` directory and remove the production database (if it exists) and also the `public/uploads` direcory:

```
rm db/production.sqlite3
rm -rf public/uploads
```

Now we can copy the live production database we saved earlier along with the
`public/uploads` directory which contains sample data files, images etc.

```
cp <previous sample_tracker dir>/db/production.sqlite3 db
cp -r <previous sample_tracker dir>/public/uploads public
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
