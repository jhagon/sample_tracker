class AddFlagIdToSamples < ActiveRecord::Migration
  def self.up
    add_column :samples, :flag_id, :integer
  end

  def self.down
    remove_column :samples, :flag_id
  end
end
