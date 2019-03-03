class CreateMovies < ActiveRecord::Migration
  def change
    create_table :movies do |t|
      t.string :my_id
      t.string :title
      t.string :backdrop_path
      t.string :release_date
      t.string :poster_path
      t.string :vote_average
      t.string :adult
      t.text :overview
      t.string :trailer

      t.timestamps
    end
  end
end
