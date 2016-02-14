class Movie < ActiveRecord::Base
    def self.possible_ratings 
        return ['G', 'PG', 'PG-13', 'R']
    end 
end
