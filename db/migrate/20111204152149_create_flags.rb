class CreateFlags < ActiveRecord::Migration
  def self.up
    create_table :flags do |t|
      t.string :name
      t.text :description
      t.timestamps
    end
  end

  def self.down
    drop_table :flags
  end
end
