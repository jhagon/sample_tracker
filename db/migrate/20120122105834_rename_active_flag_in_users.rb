class RenameActiveFlagInUsers < ActiveRecord::Migration
  def self.up
    rename_column :users, :active, :enabled
  end

  def self.down
    rename_column :users, :enabled, :active
  end
end
