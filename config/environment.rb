# Load the rails application
require File.expand_path('../application', __FILE__)

# Initialize the rails application
SampleTracker::Application.initialize!
ITEMS_PER_PAGE = 5 # num items per page for will_paginate
