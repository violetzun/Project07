class MoviesController < ApplicationController
  before_action :set_movie, only: [:show, :edit, :update, :destroy]
  before_action :role_required, except: [:index, :show,:recommend]
      respond_to :html, :js
 require 'rubygems'
  require 'rest_client'
  require 'json'
require 'will_paginate/array'
RestClient.proxy="http://192.41.170.23:3128"
  # GET /movies
  # GET /movies.json
  def index
    /@movies = Movie.all/

    /----------AJAX search-----------/
    @movies = Movie.where('lower(title) like ?', "%#{params[:q]}%".downcase)

     /------------do sort-------------/
    if (params[:sort]=="date")
      @movies = @movies.sort! {|a,b| b.release_date <=> a.release_date}
      @sortType="date"
    elsif (params[:sort]=="popular")
      @movies = @movies.sort! {|a,b| b.vote_average <=> a.vote_average}
      @sortType="popular"
    else #defult
      @sortType="all"
    end

    @movies=@movies.paginate(:per_page => 27, :page => params[:page])
    
    puts @sortType


    /----Like---/
    if (params[:movieLike]&& params[:dislike].blank?)
                       if LikeMovie.where(:movie_id => params[:movieLike], :user_id =>current_user.id).exists?
                         @likeMovie = LikeMovie.where(:movie_id => params[:movieLike], :user_id =>current_user.id).delete_all
                         else
      @likeMovie = LikeMovie.new(:user_id =>current_user.id ,:movie_id =>params[:movieLike])
      @likeMovie.save
                         end
      #redirect_to '/movies'
    elsif (params[:movieLike] && params[:dislike]== "dislike")
      @likeMovie = LikeMovie.where(:movie_id => params[:movieLike], :user_id =>current_user.id).delete_all

               #LikeMovie.destroy(@likeMovie.id)

    end
    respond_to do |format|
      format.html # index.html.erb
      format.json { render :json => @movies}
    end

  end

  def findImage(content)
    condition = /(<img)(.*?)(>)/.match(content)
    if(condition)
      image = condition[0].scan(/(src=")(.*?)(")/)
      return image[0][1]
    else
      return "0"
    end
  end
  helper_method :findImage

  def recommend
    @likes = LikeMovie.where( 'user_id =? ',current_user.id ).all
    @likeMovieList=[]
    if(@likes)
      @likes.each do |like| 
        @likeMovie = Movie.where('id =? ',like.movie_id ).first
        @likeMovieList.push(@likeMovie);
      end
    end

    @reviews = Entry.where('user_id =? ',current_user.id).all
    if(@reviews)
      @reviews.each do |review| 
        @reviewMovie = Movie.where('id =? ',review.movie_id ).first
        @likeMovieList.push(@reviewMovie);
      end
    end

    @sampleMovie= @likeMovieList.sample(3)

    @recommendList=[]
    @sampleMovie.each do |likeMovie|
      if(likeMovie)
        @resultList = searchRelated(likeMovie.my_id.to_s)
        if(@resultList)
          if(@resultList.length>0)
            @recommendList.concat(@resultList)
          end
        end
      end
    end



  end

  def searchRelated(movieID)
    /--------------------search movie----------------------/
    headers  = {:accept => "application/json"}
    @url = "http://api.themoviedb.org/3/movie/"+movieID+"/similar_movies?api_key=f87ed2628b2c673e7f6bc8e3ddba7dc7"
    begin 
      response = RestClient.get @url, headers
    rescue => e
      puts e.response
      puts "error"
      return 0;
    end

    @searchResults = JSON.parse(response)
    @searchResultsLists =[]
    i=0

    @maxResult=6
    if(@searchResults.fetch('total_results')<@maxResult)
      @maxResult=@searchResults.fetch('total_results')
    end

    if(@searchResults.fetch('total_results')!=0)
      while(i<@maxResult-1)
        @backdrop_path= @searchResults.fetch('results').fetch(i).fetch('backdrop_path')
        @id= @searchResults.fetch('results').fetch(i).fetch('id')
        @title= @searchResults.fetch('results').fetch(i).fetch('title')
        @release_date= @searchResults.fetch('results').fetch(i).fetch('release_date')
        @poster_path= @searchResults.fetch('results').fetch(i).fetch('poster_path')
        @vote_average= @searchResults.fetch('results').fetch(i).fetch('vote_average')
        @adult= @searchResults.fetch('results').fetch(i).fetch('adult')
        @mySearchResult = NowPlaying.new(@backdrop_path,@id,@title,@release_date,@poster_path,@vote_average,@adult)

        /save record to database/
        if(Movie.find_by_my_id(@id.to_s).blank?)
          puts 'new record'
          @isCreate=newMovie(@mySearchResult) #isCreate=0 if id not found
        else
          puts 'old record'
          @isCreate=1
        end

        /save to list/
        if(@poster_path && (@isCreate!=0||@isCreate==1) && @release_date)
          @searchResultsLists.push(@mySearchResult)
        end
        i = i+1
      end
    end
    return @searchResultsLists
  end


  def newMovie(item)


    /find information about this movie/
    @url = "http://api.themoviedb.org/3/movie/"+item.id.to_s+"?api_key=f87ed2628b2c673e7f6bc8e3ddba7dc7&append_to_response=trailers"
    puts @url
    puts item.id
    puts item.title

    begin 
      informationResponse = RestClient.get @url , headers
    rescue => e
      puts e.response
      puts "error"
      return 0;
    end

    @infos = JSON.parse(informationResponse)
    @overview= replaceNil(@infos.fetch('overview'))
    @trailer ="-"
    if(@infos.fetch('trailers').fetch('youtube').size>0)
      @trailer= @infos.fetch('trailers').fetch('youtube').fetch(0).fetch('source')
    end
    @movie = Movie.new(:backdrop_path=>item.backdrop_path,:my_id =>item.id ,:title =>item.title,:release_date=>item.release_date,:poster_path=>item.poster_path,:vote_average=>item.vote_average,:adult=>item.adult,:overview=> @overview,:trailer=>@trailer)
    if @movie.save
      puts @id.to_s+' : saved'
    else
      puts @id.to_s+' : not saved!!'
    end
  end

  def replaceNil(string)
    if string!=nil
      return string
    else
      return "-"
    end
  end



  # GET /movies/1
  # GET /movies/1.json
  def show
    @entryList = Entry.where('movie_id = ?',params[:id]).all
    puts params[:id]
    @movieNow = Movie.find_by_id(params[:id])
    #@movie = Movie.find_by_id(params[:id])
    puts "MYID :  "+@movieNow.my_id

    @relatedMoviesLists = searchRelated(@movieNow.my_id)
    @movie = Movie.find_by_id(params[:id])
  end

  # GET /movies/new
  def new
    @movie = Movie.new
  end

  # GET /movies/1/edit
  def edit
  end

  # POST /movies
  # POST /movies.json
  def create


    @movie = Movie.new(movie_params)

    respond_to do |format|
      if @movie.save
        format.html { redirect_to @movie, notice: 'Movie was successfully created.' }
        format.json { render action: 'show', status: :created, location: @movie }
      else
        format.html { render action: 'new' }
        format.json { render json: @movie.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /movies/1
  # PATCH/PUT /movies/1.json
  def update
    respond_to do |format|
      if @movie.update(movie_params)
        format.html { redirect_to @movie, notice: 'Movie was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @movie.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /movies/1
  # DELETE /movies/1.json
  def destroy
    @movie.destroy
    respond_to do |format|
      format.html { redirect_to movies_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_movie
      @movie = Movie.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def movie_params
      params.require(:movie).permit(:my_id, :title, :backdrop_path, :release_date, :poster_path, :vote_average, :adult, :overview, :trailer)
    end
end


class NowPlaying

  def replaceNil(string)
    if string!=nil
      return string
    else
      return "-"
    end
  end

  def initialize(backdrop_path,id,title,release_date,poster_path,vote_average,adult) 
    @backdrop_path = replaceNil(backdrop_path)
    @id =  replaceNil(id)
    @title = replaceNil(title)
    @release_date = replaceNil(release_date)
    @poster_path = replaceNil(poster_path)
    @vote_average = replaceNil(vote_average)
    @adult = replaceNil(adult)
  end


  def backdrop_path 
      @backdrop_path 
  end
  def id 
      @id 
  end
  def title 
      @title 
  end
  def release_date 
      @release_date 
  end
  def dateShow
    puts "-----------release_date---------"
    puts @release_date 
    if(!@release_date.blank?)
      @release_date.to_time.strftime('%d %b %Y')
    else
      @release_date ="-"
      @release_date
    end
  end
  def poster_path_fullPath
      @poster_path  = "http://d3gtl9l2a4fn1j.cloudfront.net/t/p/w500" + @poster_path
  end
  def poster_path
      @poster_path
  end
  def vote_average 
      @vote_average 
  end
  def adult 
      @adult 
  end

end
