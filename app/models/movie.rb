class Movie < ActiveRecord::Base
	has_many :entries
end
