class AddScrapedColumnToGrab < ActiveRecord::Migration
  def change
    add_column :grabs, :scraped, :boolean, default: false
  end
end
