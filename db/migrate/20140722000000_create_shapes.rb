class CreateShapes < ActiveRecord::Migration
  def change
    if !table_exists?('shapes')
      create_table :shapes do |t|
        # timestamp is the directory name
        # in app/assets/shapefiles
        t.integer :timestamp, null: false
        t.string :region
        t.timestamps
      end
      add_index :shapes, :timestamp, unique: true
    end

    if !table_exists?('addresses')
      create_table :addresses do |t|
        t.belongs_to :shape
        t.float :lat
        t.float :lng
        t.string :num
        t.string :street
        t.string :ward
        t.string :mun
        t.string :arc
        t.float :dist

        t.string :lonum
        t.string :lonumsuf
        t.string :hinum
        t.string :hinumsuf

        t.timestamps
      end
      add_index :addresses, :street
      #add_index :addresses, :lat
      #add_index :addresses, :lng
    end
  end
end