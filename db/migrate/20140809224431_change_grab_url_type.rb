class ChangeGrabUrlType < ActiveRecord::Migration
  def change
    change_column :grabs, :url, :text
  end
end
