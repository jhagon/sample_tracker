class ChangePageOrderColumnName < ActiveRecord::Migration
  def self.up
    rename_column :pages, :order, :priority
  end

  def self.down
    rename_column :pages, :priority, :order
  end
end
