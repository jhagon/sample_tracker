class AddCommentsToSample < ActiveRecord::Migration
  def self.up
    add_column :samples, :comments, :text
  end

  def self.down
    remove_column :samples, :comments
  end
end
