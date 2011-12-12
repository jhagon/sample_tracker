class ChangeUserrefDefaultIn_sample < ActiveRecord::Migration
  def self.up
    change_column :samples, :userref, :string
  end

  def self.down
    change_column :samples, :userref, :string, :default => nil
  end
end
