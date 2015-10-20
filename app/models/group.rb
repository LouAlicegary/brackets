class Group < ActiveRecord::Base

  has_many :brackets

  def to_i
    self.id.to_i
  end

end
