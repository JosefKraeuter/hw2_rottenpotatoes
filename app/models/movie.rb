class Movie < ActiveRecord::Base
	def self.getratings
		@ar = []		
		@ratings = self.select(:rating).uniq
		
		@ratings.each do |x|	
			@ar << x.rating
		end

		@ar = @ar.uniq.sort

end

end
