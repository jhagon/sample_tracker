class AddSpecInfoToSamples < ActiveRecord::Migration
  def self.up
    add_column :samples, :spec_info, :text
  end

  def self.down
    remove_column :samples, :spec_info
  end
end
