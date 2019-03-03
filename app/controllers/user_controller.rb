class UserController < ApplicationController
  def index
    @users = User.all

   
    #For popular user
    @hash_user ||= topLikeUser()
    @count_user = Hash[@hash_user.sort.reverse]
    puts @count_user
    @array_user = @count_user.collect do |key,value|
      key.to_s
    end
    #Get users with max likes entries
    @list_user = @array_user.collect do |value|
      User.find(value)
    end
       @user_list = @list_user

  end

   def bann
     @users = User.all
     if (params[:user_id]&& params[:role_id])
       if User.where(:id => params[:user_id]).exists?
         user = User.find(params[:user_id])
         puts 'Exists'
         puts params[:role_id]
         if (params[:role_id]=='2')
           user.update(role_id: 3)
           user.save
           puts 'Changing to role_id 3'

         elsif (params[:role_id]=='1')
           puts 'Do nothing Admin'

         elsif (params[:role_id]=='3')
           user.update(role_id: 2)
           user.save
           puts 'Changing back to role_id 2'

         end

       else
         puts 'No user found'
       end

     end
     render "user/index"
   end

  def topLikeEntry
    @entries = Entry.all
    @count = LikeEntry.group(:entry_id).count
    #Return Hash of [entry_id=>count]
     puts @count
    return @count
  end

  def topLikeUser
    @entries = Entry.all
    @count_like = LikeEntry.group(:owner_id).count
    #Return Hash of [owner_id=>count]
    puts @count_like
    return @count_like
  end

end
