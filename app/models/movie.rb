class Movie < ActiveRecord::Base
    
    def self.ratings
        Movie.uniq.pluck(:rating)
    end
end
