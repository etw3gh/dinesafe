class AddTimestampToGrab < ActiveRecord::Migration
  def change
    add_column :grabs, :timestamp, :integer, default: Time.now.to_i
  end
end
