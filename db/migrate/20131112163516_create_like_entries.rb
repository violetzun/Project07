class CreateLikeEntries < ActiveRecord::Migration
  def change
    create_table :like_entries do |t|
      t.references :user, index: true
      t.references :entry, index: true

      t.timestamps
    end
  end
end
