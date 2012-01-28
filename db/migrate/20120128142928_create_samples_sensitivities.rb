class CreateSamplesSensitivities < ActiveRecord::Migration
  def self.up
    create_table :samples_sensitivities, :id => false do |t|
      t.references :sample, :null => false
      t.references :sensitivity, :null => false
    end
  end

  def self.down
    drop_table :samples_sensitivities
  end

end
