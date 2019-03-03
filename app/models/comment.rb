class Comment < ActiveRecord::Base
  	belongs_to :user
  	belongs_to :entry

  	def pretty_date
		created_at.strftime( '%b %d, %Y at %I:%M %p' )
	end


end
