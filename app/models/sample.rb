class Sample < ActiveRecord::Base
  attr_accessible :hazard_ids, :code, :cif, :synth, :coshh_name, :coshh_desc, :coshh_info, :coshh_haz, :params, :priority, :powd, :chiral, :cost_code, :barcode, :user_id, :flag_id, :userref
  has_and_belongs_to_many :hazards
  belongs_to :user
  belongs_to :flag

  validates :cif,        :presence => true
  validates :synth,      :presence => true
  validates :coshh_name, :presence => true
  validates :coshh_info, :presence => true
  validates :coshh_desc, :presence => true
  validates :params,     :presence => true
  validates :priority,   :format => {
    :with     => %r{^[1-9]$},
    :message  => 'must be a single integer between 1 and 9.'
  }
  validates :userref,    :format => {
    :with     => %r{^[A-Z,a-z,0-9]+$},
    :message  => 'must be alphanumeric sequence of characters without spaces.'
  }

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
