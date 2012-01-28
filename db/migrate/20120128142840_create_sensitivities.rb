class CreateSensitivities < ActiveRecord::Migration
  def self.up
    create_table :sensitivities do |t|
      t.string :name
      t.text :description
      t.timestamps
    end
  end

  def self.down
    drop_table :sensitivities
  end
end
