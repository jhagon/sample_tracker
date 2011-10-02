class RemoveHazardFromSample < ActiveRecord::Migration
  def self.up
    remove_column :samples, :coshh_haz
  end

  def self.down
    add_column :samples, :coshh_haz, :string
  end
end
