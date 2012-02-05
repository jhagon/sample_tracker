# Load the rails application
require File.expand_path('../application', __FILE__)

# Initialize the rails application
SampleTracker::Application.initialize!
ITEMS_PER_PAGE = 5 # num items per page for will_paginate

###################  SPECIFIC GLOBAL VARS ####################
TEXTILE_REF_URL = "http://redcloth.org/textile/"
TEXTILE_QUICK_REF_URL = "http://en.wikipedia.org/wiki/Textile_%28markup_language%29"

