class CreateArchives < ActiveRecord::Migration
  def change
    if !table_exists?('archives')
      create_table :archives do |t|
        t.integer :timestamp, null: false
        t.string :filename
        t.string :fullpath
        t.string :region
        t.string :subregion
        t.boolean :fresh
        t.timestamps
      end
      add_index :archives, :timestamp, unique: true
    end
  end
end
