class CreateSolutions < ActiveRecord::Migration
  def change
    create_table :solutions do |t|
      t.string :name
      t.string :explanation
      t.references :project, index: true

      t.timestamps
    end
  end
end
