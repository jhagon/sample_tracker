class Flag < ActiveRecord::Base
  attr_accessible :name, :description
  has_many :samples
end
