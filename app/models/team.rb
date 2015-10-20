class Team < ActiveRecord::Base

  def to_i
    self.id
  end

end
