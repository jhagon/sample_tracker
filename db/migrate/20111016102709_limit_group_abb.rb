class LimitGroupAbb < ActiveRecord::Migration
  def self.up
    change_column :groups, :group_abbr, :string, :limit => 3
  end

  def self.down
    change_column :groups, :group_abbr, :string, :limit => 255
  end
end
