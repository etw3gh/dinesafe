class CreateGrabs < ActiveRecord::Migration
  def change
    create_table :grabs do |t|
      t.string :category
      t.string :path
      t.string :url
      t.boolean :downloaded
      t.timestamps
    end
  end
end
