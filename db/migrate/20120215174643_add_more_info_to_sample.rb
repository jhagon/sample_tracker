class AddMoreInfoToSample < ActiveRecord::Migration
  def self.up
    add_column :samples, :colour, :text
    add_column :samples, :size, :text
    add_column :samples, :shape, :text
  end

  def self.down
    remove_column :samples, :shape
    remove_column :samples, :size
    remove_column :samples, :colour
  end
end
