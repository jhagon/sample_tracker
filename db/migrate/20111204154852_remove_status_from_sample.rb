class RemoveStatusFromSample < ActiveRecord::Migration
  def self.up
   remove_column :samples, :status
  end

  def self.down
    add_column :samples, :status, :string
  end
end
