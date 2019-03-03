class EntriesController < ApplicationController
  before_action :set_entry, only: [:show, :edit, :update, :destroy]
  before_action :login_required, except: [:index, :show]
  #before_action :role_required, except: [:index, :show]
  require 'rubygems'
  require 'rest_client'
  require 'json'
require 'will_paginate/array'


RestClient.proxy="http://192.41.170.23:3128"
  def render_pic
     render "layouts/upload_pic"
  end


  def timeline
    if params[:user_id].blank?
      @user = current_user
    else
      @user = User.find(params[:user_id])
    end

    @entries = Entry.where(user_id: @user.id).order("created_at DESC")

    render "entries/timeliner"
  end

  def uploadFile
     uploaded_io = params[:picture]
  File.open(Rails.root.join('public', 'uploads', uploaded_io.original_filename), 'wb') do |file|
    file.write(uploaded_io.read)
  end
    @user = User.find(current_user.id)
   @file_name = uploaded_io.original_filename
   @user.update_attributes(:image => 'uploads/'+ @file_name)
#other processing
@user.save
    redirect_to '/home'

  end

  def trailer

  end

 def profile
  if params[:user_id].blank?
    @user = current_user
  else
    @user = User.find(params[:user_id])
  end

     @entries = Entry.where(user_id: @user.id).order("created_at DESC")

     render "layouts/profile"
  end

  def searchMovie
    if(params[:movieName].blank?)
      @searchResultsLists=[]
      puts "nosearch"
    else
      puts params[:movieName]
      @searchResultsLists = searchMovieItem(params[:movieName])
    end
  end

  def searchMovieItem(query)

    @splitquery = query.split
    @myquery=""
    if(@splitquery.length>0) 
      @splitquery.each do |word|
        @myquery=@myquery+word+"%20"
      end
    else
      @myquery = query
    end
    /--------------------search movie----------------------/
    headers  = {:accept => "application/json"}
    @url = "http://api.themoviedb.org/3/search/movie?api_key=f87ed2628b2c673e7f6bc8e3ddba7dc7&query="+@myquery
    response = RestClient.get @url, headers
    @searchResults = JSON.parse(response)
    @searchResultsLists =[]
    i=0
    @maxResult=5
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
  helper_method :searchMovieItem

  def initializeNowItem
    /--------------------Now Playing----------------------/
    headers  = {:accept => "application/json"}
    @url = "http://api.themoviedb.org/3/movie/now_playing?api_key=f87ed2628b2c673e7f6bc8e3ddba7dc7&page=1?language=english"
    response = RestClient.get @url, headers
    @nowPlayings = JSON.parse(response)
    @nowPlayingsLists =[]
    i=0

    while(i<10)
      @backdrop_path= @nowPlayings.fetch('results').fetch(i).fetch('backdrop_path')
      @id= @nowPlayings.fetch('results').fetch(i).fetch('id')
      @title= @nowPlayings.fetch('results').fetch(i).fetch('title')
      @release_date= @nowPlayings.fetch('results').fetch(i).fetch('release_date')
      @poster_path= @nowPlayings.fetch('results').fetch(i).fetch('poster_path')
      @vote_average= @nowPlayings.fetch('results').fetch(i).fetch('vote_average')
      @adult= @nowPlayings.fetch('results').fetch(i).fetch('adult')
      @myNowPlaying = NowPlaying.new(@backdrop_path,@id,@title,@release_date,@poster_path,@vote_average,@adult)

      /save record to database/
      if(Movie.find_by_my_id(@id.to_s).blank?)
        puts 'new record'
        @isCreate=newMovie(@myNowPlaying) #isCreate=0 if id not found
      else
        puts 'old record'
        @isCreate=1
      end

      /save to list/
      if(@poster_path && (@isCreate!=0||@isCreate==1))
        @nowPlayingsLists.push(@myNowPlaying)
      end
      i = i+1
    end
    return @nowPlayingsLists
  end


  def initializePopularitem
     /--------------------popular----------------------/
    headers  = {:accept => "application/json"}
    @url = "http://api.themoviedb.org/3/movie/popular?api_key=f87ed2628b2c673e7f6bc8e3ddba7dc7"
    response = RestClient.get @url, headers
    @populars = JSON.parse(response)
    @popularLists =[]
    i=0

    while(i<8)
      @backdrop_path= @populars.fetch('results').fetch(i).fetch('backdrop_path')
      @id= @populars.fetch('results').fetch(i).fetch('id')
      @title= @populars.fetch('results').fetch(i).fetch('title')
      @release_date= @populars.fetch('results').fetch(i).fetch('release_date')
      @poster_path= @populars.fetch('results').fetch(i).fetch('poster_path')
      @vote_average= @populars.fetch('results').fetch(i).fetch('vote_average')
      @adult= @populars.fetch('results').fetch(i).fetch('adult')

      @myPopular = NowPlaying.new(@backdrop_path,@id,@title,@release_date,@poster_path,@vote_average,@adult)
      
      /save record to database/
      if(Movie.find_by_my_id(@id.to_s).blank?)
        puts 'new record'
        @isCreate=newMovie(@myPopular)   #isCreate=0 if id not found
      else
        @isCreate=1
        puts 'old record'
      end

      /save to list/
      if(@poster_path && (@isCreate!=0||@isCreate==1))
        @popularLists.push(@myPopular)
      end
      i = i+1
    end
    return @popularLists
  end

  # GET /entries
  # GET /entries.json
  def index
    @entries = Entry.all.order("id DESC")
    @nowPlayingsLists ||= initializeNowItem()
    @popularLists ||= initializePopularitem()

    /------------do report-------------/
    if (params[:report]=='1')
      puts 'report'
      @editEntry = Entry.find_by_id(params[:entry_id])
      @change = "report_abuse = " + (@editEntry.report_abuse+1).to_s
      @condition = "id="+params[:entry_id].to_s

      Entry.update_all( @change, @condition)
    else
       puts 'no report'
    end
    /------Entry Like ----/
    if (params[:entryLike]&& params[:dislike].blank?)
      if LikeEntry.where(:entry_id => params[:entryLike], :user_id =>current_user.id).exists?
        @likeEntry = LikeEntry.where(:entry_id => params[:entryLike], :user_id =>current_user.id).delete_all
      else
        @likeEntry = LikeEntry.new(:owner_id => Entry.find_by_id(params[:entryLike]).user_id ,:user_id =>current_user.id ,:entry_id =>params[:entryLike])
        @likeEntry.save
        post_like(@likeEntry)
      end
      #redirect_to '/movies'
    elsif (params[:entryLike] && params[:dislike]== "dislike")
      @likeEntry = LikeEntry.where(:entry_id => params[:entryLike], :user_id =>current_user.id).delete_all

      #LikeMovie.destroy(@likeMovie.id)
    end

  end

  def post_like(like)

    if (!like.user.image)
      @pic="/default.png"
    else
      @pic = "/"+like.user.image
    end



    @myLike=Mylike.new("1",like.id,like.user_id,like.entry_id,like.created_at,like.user.username,@pic,like.entry.user_id,current_user.id,like.entry.topic)


    require  'net/http'
    req = Net::HTTP::Post.new( '/' , initheader = { 'Content-Type' =>  'application/json' })
    req.body = @myLike.to_json(only: [:isLike,:id, :user_id, :entry_id,:created_at,:username,:pic],
                               methods: :pretty_date)
    response = Net::HTTP.new( '192.41.170.118' ,  '3001' ).start {|http| http.request(req) }
    return 
  end



  def review
    @entries = Entry.all.order("id DESC").paginate(:per_page => 20, :page => params[:page])
   
    
    /------------do report-------------/
    if (params[:report]=='1')
      puts 'report'
      @editEntry = Entry.find_by_id(params[:entry_id])
      @change = "report_abuse = " + (@editEntry.report_abuse+1).to_s
      @condition = "id="+params[:entry_id].to_s

      Entry.update_all( @change, @condition)
    else
       puts 'no report'
    end
    
    /------------do sort-------------/
    if (params[:sort]=="date")
      @sortType="date"

    elsif (params[:sort]=="popular")
      @sortType="popular"
      @count = LikeEntry.group(:entry_id).order('count_entry_id asc').count('entry_id')
      @count = Hash[@count.sort_by{|k,v| v}.reverse]
     @array = @count.collect do |key,value|
        key.to_s
	
     end
      #Get entries with max likes entries
      @list = @array.collect do|key,value|
	
        Entry.find(key)
      end
      @entries=@list
      
      @entries = @entries.paginate(:per_page => 20, :page => params[:page])
      
    else #defult
      @sortType="all"
    end
    puts @sortType
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

  # GET /entries/1
  # GET /entries/1.json
  def show
  end

  # GET /entries/new
  def new
    @entry = Entry.new
    @initTopic = Movie.where('title=?',params[:q]).all
    @initTopic=@initTopic.to_json
    puts @initTopic


 end


  



  # GET /entries/1/edit
  def edit
  end
  

  # POST /entries
  # POST /entries.json
  def findMovieName(entry)

  end

  def create
    @entry = Entry.new(entry_params)

    puts "topic"
    puts params[:topic]
    @entry.user_id = current_user.id
    @entry.report_abuse= 0

    /now @entry.topic = tokenValue = id of selected movie/
    @entry.movie_id = @entry.topic
	if @entry.movie 
	
    @entry.topic = @entry.movie.title
end

    respond_to do |format|
      if @entry.movie
@entry.save
        format.html { redirect_to @entry, notice: 'Entry was successfully created.' }
        format.json { render action: 'show', status: :created, location: @entry }
      else
        format.html { render action: 'new' }
        format.json { render json: @entry.errors, status: :unprocessable_entity }
      end
    end
  end

  def replaceNil(string)
    if string!=nil
      return string
    else
      return "-"
    end
  end

  def newComment
    @comment = Comment.new(:comment=>params[:comment] , :user_id =>current_user.id ,:entry_id =>params[:blogID])

    @comment.user_id = current_user.id
      if @comment.save
        post_comment(@comment)
        redirect_to '/entries/'+params[:blogID]
      else
        redirect_to '/entries/'+params[:blogID]
      end
  end

  def post_comment(comment)
    if (!comment.user.image)
      @pic="/default.png"
    else
      @pic = "/"+comment.user.image
    end
    @myComment=MyComment.new("1",comment.id,comment.comment,comment.user_id,comment.entry_id,comment.created_at,comment.user.username,@pic,comment.entry.user_id,current_user.id,comment.entry.topic)


    require  'net/http'
    req = Net::HTTP::Post.new( '/' , initheader = { 'Content-Type' =>  'application/json' })
    req.body = @myComment.to_json(only: [ :id, :comment, :user_id, :entry_id,:created_at,:username,:pic],
                               methods: :pretty_date)
    response = Net::HTTP.new( '192.41.170.118' ,  '3001' ).start {|http| http.request(req) }
    return 
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



  # PATCH/PUT /entries/1
  # PATCH/PUT /entries/1.json
  def update
    respond_to do |format|
      if @entry.update(entry_params)
        format.html { redirect_to @entry, notice: 'Entry was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @entry.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /entries/1
  # DELETE /entries/1.json
  def destroy
    @entry.destroy
    respond_to do |format|
      format.html { redirect_to entries_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_entry
      @entry = Entry.find(params[:id])
      @comments = Comment.find( :all, :conditions => ['entry_id= ? ',params[:id]],:order => 'created_at DESC')
      

    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def entry_params

      params.require(:entry).permit(:topic, :content, :user_id ,:report_abuse ,:movie_id)
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
      @release_date .to_time.strftime('%d %b %Y')
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


class MyComment

  def initialize(isComment,id,comment,user_id,entry_id,created_at,username,pic,entry_owner,current_user,entry_topic) 
    @isComment=isComment
    @id =  id
    @comment = comment
    @user_id = user_id
    @entry_id = entry_id
    @created_at = created_at
    @username=username
    @pic = pic
    @entry_owner=entry_owner
    @current_user=current_user
    @entry_topic=entry_topic
  end

  def isComment
    @isComment
  end

  def id 
      @id 
  end
  def comment 
      @comment 
  end
  def user_id 
      @user_id 
  end
  def entry_id
      @entry_id
  end
  def created_at
      @created_at
  end
  def username
      @username
  end
  def pic 
      @pic
  end
  def entry_owner
    @entry_owner
  end
  def current_user
    @current_user
  end
  def entry_topic
    @entry_topic
  end

end


class Mylike

  def initialize(isLike,id,user_id,entry_id,created_at,username,pic,entry_owner,current_user,entry_topic) 
    @isLike=isLike
    @id =  id
    @user_id = user_id
    @entry_id = entry_id
    @created_at = created_at
    @username=username
    @pic = pic
    @entry_owner=entry_owner
    @current_user=current_user
    @entry_topic=entry_topic
  end


  def isLike
    @isLike
  end

  def id 
      @id 
  end
  def user_id 
      @user_id 
  end
  def entry_id
      @entry_id
  end
  def created_at
      @created_at
  end
  def username
      @username
  end
  def pic 
      @pic
  end
  def entry_owner
    @entry_owner
  end
  def current_user
    @current_user
  end
  def entry_topic
    @entry_topic
  end

end
