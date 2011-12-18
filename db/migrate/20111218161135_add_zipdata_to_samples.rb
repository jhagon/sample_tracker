class AddZipdataToSamples < ActiveRecord::Migration
  def self.up
    add_column :samples, :zipdata, :string
  end

  def self.down
    remove_column :samples, :zipdata
  end
end
