class Sample < ActiveRecord::Base
  attr_accessible :code, :cif, :synth, :coshh_name, :coshh_desc, :coshh_info, :coshh_haz, :params, :status, :priority, :powd, :chiral, :cost_code, :barcode
  mount_uploader :synth, SynthUploader
end
