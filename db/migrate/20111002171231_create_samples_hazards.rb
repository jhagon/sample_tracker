class CreateSamplesHazards < ActiveRecord::Migration
  def self.up
    create_table :hazards_samples, :id => false do |t|
      t.references :sample, :null => false
      t.references :hazard, :null => false
    end
  end

  def self.down
    drop_table :hazards_samples
  end
end
