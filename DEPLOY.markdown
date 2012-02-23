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
