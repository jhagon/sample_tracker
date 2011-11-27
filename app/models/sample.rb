class Sample < ActiveRecord::Base
  attr_accessible :hazard_ids, :code, :cif, :synth, :coshh_name, :coshh_desc, :coshh_info, :coshh_haz, :params, :status, :priority, :powd, :chiral, :cost_code, :barcode, :user_id
  has_and_belongs_to_many :hazards
  belongs_to :user

  validates :cif,        :presence => true
  validates :synth,      :presence => true
  validates :coshh_name, :presence => true
  validates :coshh_info, :presence => true
  validates :coshh_desc, :presence => true
  validates :params,     :presence => true
  validates :status,     :presence => true
  validates :priority,   :presence => true

  mount_uploader :synth, SynthUploader

  before_create :make_barcode

  private

  def make_barcode
  # create random 12 digit uppercase alphanumeric string
  # then set this to be the barcode.
    self.barcode = rand_alphanums
  end

  def rand_alphanums
  # create random 12 digit lowercase alphanumeric string
    alphanums = [('0'..'9'),('A'..'Z')].map {|range| range.to_a}.flatten
    (0...11).map { alphanums[Kernel.rand(alphanums.size)] }.join
  end

end
