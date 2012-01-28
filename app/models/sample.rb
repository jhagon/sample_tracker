class Sample < ActiveRecord::Base
  attr_accessible :store_ids, :sensitivity_ids, :hazard_ids, :code, :cif, :synth, :coshh_name, :coshh_desc, :coshh_info, :coshh_haz, :params, :priority, :powd, :chiral, :cost_code, :barcode, :user_id, :flag_id, :userref, :zipdata, :sampleimage, :reference, :comments
  has_and_belongs_to_many :hazards
  has_and_belongs_to_many :sensitivities
  has_and_belongs_to_many :stores
  belongs_to :user
  belongs_to :flag

HUMANIZED_ATTRIBUTES = {

  :userref        => "your reference",
  :code           => "sample code",
  :cif            => "chemical formula",
  :synth          => "synthetic route diagram",
  :coshh_name     => "solvent name",
  :coshh_desc     => "sample description",
  :coshh_info     => "COSHH handling information",
  :params         => "parameters field",
  :reference      => "published reference",
  :zipdata        => "data file",
  :sampleimage    => "sample image file",
  :cost_code      => "cost centre code",

}

def self.human_attribute_name(attr, options={})

  HUMANIZED_ATTRIBUTES[attr.to_sym] || super

end

  validate :must_specify_sensitivity
  validate :must_specify_store
  validate :comment_must_not_be_blank_if_other_specified

  validates :reference,	 :uniqueness => true, :allow_blank => true
  validates :code,	 :uniqueness => true
  validates :cif,        :presence => true
  validates :synth,      :presence => true
  validates :coshh_name, :presence => true
  validates :coshh_info, :presence => true
  validates :coshh_desc, :presence => true
  validates :params,     :presence => true
  validates :priority,   :format => {
    :with     => %r{^[1-9]$},
    :message  => 'must be a single integer between 1 and 9'
  }
  validates :userref,    :format => {
    :with     => %r{^[A-Z,a-z,0-9]+$},
    :message  => 'must be alphanumeric sequence of characters without spaces.'
  }
  validates :cost_code,  :presence => true

  mount_uploader :synth, SynthUploader
  mount_uploader :zipdata, ZipdataUploader
  mount_uploader :sampleimage, SampleimageUploader

  before_create :make_barcode

  after_update :send_email_after_status_change

  def send_email_after_status_change
    if (self.flag_id_changed?)
      flag=Flag.find(self.flag_id_was)
      SampleMailer.sample_update(self, flag).deliver
    end
  end

  def must_specify_sensitivity
    if (sensitivities.size == 0 )
      errors.add('', 'you must specify sample sensitivity')
    end
  end

  def must_specify_store
    if (stores.size == 0 )
      errors.add('', 'you must specify sample storage requirements')
    end
  end
 
  def comment_must_not_be_blank_if_other_specified
    found_other = false
    for s in stores
      if (s.name == 'other')
        found_other = true
      end 
    end
    for s in sensitivities
      if (s.name == 'other')
        found_other = true
      end 
    end
    if ( found_other && ( comments =~ /^\s*$/ || comments.nil?) )
      errors.add('', "you have specified  'other' for either samples or storage - please give details in the comments box")
    end
  end

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
