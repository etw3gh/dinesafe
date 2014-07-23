class CreateVenues < ActiveRecord::Migration
  def change
    if !table_exists?('venues')
      create_table :venues do |t|
        t.integer :eid
        t.string :name
        t.string :address
        t.string :etype
        t.float :lat
        t.float :lng
        t.integer :mipy
        t.timestamps
      end
      add_index :venues, :eid, unique: true
    end

    if !table_exists?('events')
      create_table :events do |t|
        t.belongs_to :venue
        t.integer :rid
        t.integer :iid
        t.string :status
        t.string :details
        t.string :date
        t.string :severity
        t.string :action
        t.string :outcome
        t.string :fine
        t.integer :version
        t.timestamps
      end
      add_index :events, :iid
    end
  end
end