class CreateSamplesStores < ActiveRecord::Migration
  def self.up
    create_table :samples_stores, :id => false do |t|
      t.references :sample, :null => false
      t.references :store, :null => false
    end
  end

  def self.down
    drop_table :samples_stores
  end
end
