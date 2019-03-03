class Project < ActiveRecord::Base
	
 has_many :solutions

def self.divide(x,y)
 if(y==0) 
File.open('/home/violet/Project07/log/production.log', 'w') do |f2| f2.puts "About to divide by 0\n" 
end 
end 
return x / y
end




def self.viewSource
	require 'open-uri'
	html = open('http://www.yahoo.com').read
	sourcePage = /(trendingnow_trend-list fw-b)(.*?)(\/ol)/.match(html)
	#myTrendList = /(title=")(.*?)(">)/.match_all(sourcePage[0])
	myTrendList = sourcePage[0].scan(/(title=")(.*?)(">)/)
	myTrendLink = sourcePage[0].scan(/(href=")(.*?)(")/)
	return myTrendList,myTrendLink
end



end
