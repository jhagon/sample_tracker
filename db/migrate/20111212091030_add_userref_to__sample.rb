class AddUserrefTo_sample < ActiveRecord::Migration
  def self.up
    add_column :samples, :userref, :string, :default => nil
  end

  def self.down
    remove_column :samples, :userref
  end
end
