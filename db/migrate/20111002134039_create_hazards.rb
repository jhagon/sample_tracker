class CreateHazards < ActiveRecord::Migration
  def self.up
    create_table :hazards do |t|
      t.string :hazard_desc
      t.string :hazard_abbr
      t.timestamps
    end
  end

  def self.down
    drop_table :hazards
  end
end
