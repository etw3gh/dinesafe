class AddNameToAddress < ActiveRecord::Migration
  def self.up
    add_column :addresses, :name, :string
  end
end