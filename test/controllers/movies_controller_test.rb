require 'test_helper'

class MoviesControllerTest < ActionController::TestCase
  setup do
    @movie = movies(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:movies)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create movie" do
    assert_difference('Movie.count') do
      post :create, movie: { adult: @movie.adult, backdrop_path: @movie.backdrop_path, my_id: @movie.my_id, overview: @movie.overview, poster_path: @movie.poster_path, release_date: @movie.release_date, title: @movie.title, trailer: @movie.trailer, vote_average: @movie.vote_average }
    end

    assert_redirected_to movie_path(assigns(:movie))
  end

  test "should show movie" do
    get :show, id: @movie
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @movie
    assert_response :success
  end

  test "should update movie" do
    patch :update, id: @movie, movie: { adult: @movie.adult, backdrop_path: @movie.backdrop_path, my_id: @movie.my_id, overview: @movie.overview, poster_path: @movie.poster_path, release_date: @movie.release_date, title: @movie.title, trailer: @movie.trailer, vote_average: @movie.vote_average }
    assert_redirected_to movie_path(assigns(:movie))
  end

  test "should destroy movie" do
    assert_difference('Movie.count', -1) do
      delete :destroy, id: @movie
    end

    assert_redirected_to movies_path
  end
end
