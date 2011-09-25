class Asset < ActiveRecord::Base
  attr_accessible :document, :description
  mount_uploader :document, DocumentUploader
end
