class CreateSamples < ActiveRecord::Migration
  def self.up
    create_table :samples do |t|
      t.string :code
      t.string :cif
      t.string :synth
      t.string :coshh_name
      t.string :coshh_desc
      t.text :coshh_info
      t.string :coshh_haz
      t.string :params
      t.string :status
      t.integer :priority
      t.boolean :powd
      t.boolean :chiral
      t.string :cost_code
      t.string :barcode
      t.timestamps
    end
  end

  def self.down
    drop_table :samples
  end
end
