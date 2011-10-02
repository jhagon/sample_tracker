class Hazard < ActiveRecord::Base
  attr_accessible :hazard_desc, :hazard_abbr
  has_and_belongs_to_many :samples
end
