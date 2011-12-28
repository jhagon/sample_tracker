class AddLeaderToUser < ActiveRecord::Migration
  def self.up
    add_column :users, :leader, :boolean, :default => false
  end

  def self.down
    remove_column :users, :leader
  end
end
