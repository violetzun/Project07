json.array!(@movies) do |movie|
  json.extract! movie, :my_id, :title, :backdrop_path, :release_date, :poster_path, :vote_average, :adult, :overview, :trailer
  json.url movie_url(movie, format: :json)
end
