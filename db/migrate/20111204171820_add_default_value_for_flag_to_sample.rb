class AddDefaultValueForFlagToSample < ActiveRecord::Migration
  def self.up
    change_column :samples, :flag_id, :integer, :default => 1, :null => false
  end

  def self.down
    change_column :samples, :flag_id, :integer
  end
end
