class Group < ActiveRecord::Base
  validates :group_abbr, :length => { :is => 3 }, :uniqueness => true
  validates :group_desc, :presence => true
  validates_format_of :group_abbr, :with => /[A-Z]{3}/
  attr_accessible :group_abbr, :group_desc
  has_many :users
  has_many :samples, :through => :users
end
