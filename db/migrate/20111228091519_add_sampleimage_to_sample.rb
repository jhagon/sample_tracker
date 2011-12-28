class AddSampleimageToSample < ActiveRecord::Migration
  def self.up
    add_column :samples, :sampleimage, :string
  end

  def self.down
    remove_column :samples, :sampleimage
  end

end
