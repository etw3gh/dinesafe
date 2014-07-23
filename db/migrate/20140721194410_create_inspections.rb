class CreateInspections < ActiveRecord::Migration
  def change
    create_table :inspections do |t|
      t.integer :rid
      t.integer :eid
      t.integer :iid
      t.string :name
      t.string :etype
      t.string :status
      t.string :details
      t.string :date
      t.string :severity
      t.string :action
      t.string :outcome
      t.string :fine
      t.string :address
      t.integer :mipy
      t.integer :version
    end
    add_index :inspections, :iid
  end
end
