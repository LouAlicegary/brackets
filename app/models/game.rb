class Game < ActiveRecord::Base

  belongs_to :bracket
  belongs_to :round
  has_many :picks

  scope :round, -> (round_id) { where(round_id: round_id).order("region ASC, id ASC") }

  def to_i
    self.id
  end

end
