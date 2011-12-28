class AddReferenceToSample < ActiveRecord::Migration
  def self.up
    add_column :samples, :reference, :string
  end

  def self.down
    remove_column :samples, :reference
  end
end
