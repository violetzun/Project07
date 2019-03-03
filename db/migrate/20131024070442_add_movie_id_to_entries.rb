class AddMovieIdToEntries < ActiveRecord::Migration
  def change
    add_column :entries, :movie_id, :integer
  end
end
