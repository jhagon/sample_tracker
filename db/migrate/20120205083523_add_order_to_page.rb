class AddOrderToPage < ActiveRecord::Migration
  def self.up
    add_column :pages, :order, :integer, :default => 1
  end

  def self.down
    remove_column :pages, :order
  end
end
