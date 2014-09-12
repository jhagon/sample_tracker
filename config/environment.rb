# Load the rails application
require File.expand_path('../application', __FILE__)

# Initialize the rails application
SampleTracker::Application.initialize!
ITEMS_PER_PAGE = 10 # default num items per page for will_paginate

###################  SPECIFIC GLOBAL VARS ####################
TEXTILE_REF_URL = "http://redcloth.org/textile/"
CRYS_EMAIL = "xray.cryst@ncl.ac.uk"
LOCAL_ADMIN_EMAIL = "crysadmin@milkyway.ncl.ac.uk"
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
QUEUE_INTRO_TEXT = "The following gives an appoximate wait time before your sample will be analysed. The actual time will vary depending on sample quality and priority number."
DLS_VISIT_DATE = "31/06/2012"
DLS_QUEUE_INTRO_TEXT = "The following samples are awaiting analysis at the Diamond Light Source (DLS). The next visit to DLS is scheduled for #{DLS_VISIT_DATE}."
REF_QUEUE_INTRO_TEXT = "The following samples are awaiting further refinement after initial data collection."
TERMINATION_MESSAGE ="Please collect your sample from Crystallography. Any samples that are not collected within a month of the resolution of the submission will be disposed of."
