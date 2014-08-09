class CreateLatestArchive < ActiveRecord::Migration
  def change
    create_table :latest_archives do |t|
      t.string :category
      t.integer :headstamp
    end
    add_index :latest_archives, :category, unique: true
  end
end
