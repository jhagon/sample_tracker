source 'http://rubygems.org'

gem 'rails', '3.0.6'
gem 'sqlite3-ruby', :require => 'sqlite3'

# redcloth provides a neat textile interface

gem 'RedCloth' # note case sensitive!

# need carrierwave for file uploading with
# rmagick useful for image scaling etc.

gem "rmagick"
gem "carrierwave"

# barcode stuff - chunky_png needed for barcode 
# PNG output from barby.

gem "barby"
gem "chunky_png"

# PDF middleware
#
#gem "pdfkit"
#

#
# Use prawn for PDF generation
#
gem "prawn"

# use the devise gem for authentication

gem 'devise', '1.4.9'

# use cancan for authorization

gem "cancan"

# use will_paginate for pagination

gem "will_paginate", "> 3.0"

group :development do
  gem 'rspec-rails', '2.0.1'
  gem 'mocha'
  gem 'faker'
  gem "nifty-generators"
end

group :test do
  gem 'mocha'
  gem 'rspec', '2.0.1'
end
