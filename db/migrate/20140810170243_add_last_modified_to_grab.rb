class AddLastModifiedToGrab < ActiveRecord::Migration
  def change
    add_column :grabs, :last_modified, :integer
  end
end
