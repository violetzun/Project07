class CreateEntries < ActiveRecord::Migration
  def change
    create_table :entries do |t|
      t.string :topic
      t.string :content
      t.references :user, index: true
		
      t.timestamps
    end

  end
end
