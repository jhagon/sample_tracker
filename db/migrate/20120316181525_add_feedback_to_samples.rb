class AddFeedbackToSamples < ActiveRecord::Migration
  def self.up
    add_column :samples, :feedback, :text
  end

  def self.down
    remove_column :samples, :feedback
  end
end
