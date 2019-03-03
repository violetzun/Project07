class AddOwnerIdToLikeEntries < ActiveRecord::Migration
  def change
    add_column :like_entries, :owner_id, :integer
  end
end
