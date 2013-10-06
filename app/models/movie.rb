class Movie < ActiveRecord::Base
  def get_ratings
    return ['G', 'PG', 'PG-13', 'R']
  end
end
