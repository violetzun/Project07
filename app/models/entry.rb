class Entry < ActiveRecord::Base
  belongs_to :user
  belongs_to :movie
  has_many :like_entries
 
end

