class DeleteFreshFromArchive < ActiveRecord::Migration
  def change
    remove_column :archives, :fresh
    remove_column :archives, :subregion
    add_column :archives, :headstamp, :integer
  end
end
