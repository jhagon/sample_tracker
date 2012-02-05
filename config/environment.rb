# Load the rails application
require File.expand_path('../application', __FILE__)

# Initialize the rails application
SampleTracker::Application.initialize!
ITEMS_PER_PAGE = 5 # num items per page for will_paginate

###################  SPECIFIC GLOBAL VARS ####################
TEXTILE_REF_URL = "http://redcloth.org/textile/"
TEXTILE_QUICK_REF_URL = "http://en.wikipedia.org/wiki/Textile_%28markup_language%29"
SAMPLE_INTRO_TEXT = "a unique code and a barcode will be
automatically generated on submission of this form when a new sample
is created. For synthetic route files, please use either the JPG or PNG
bitmap image format.
Note further that for security reasons, if there are validation errors
in the form, you will have to re-select the names of uploaded files.
Also remeber to set the priority number, the form will not validate unless
you do this (if you are not going to submit several samples in a short
space of time we suggest setting the priority number to 1)."


