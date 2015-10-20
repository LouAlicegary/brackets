class Pick < ActiveRecord::Base

  belongs_to :bracket
  belongs_to :game
  belongs_to :team

  scope :right, -> { where(result: "right") }
  scope :wrong, -> { where(result: "wrong") }
  scope :eliminated, -> { where(result: "eliminated") }
  scope :uncertain, -> { where(result: "") }

  scope :round, -> (round_id) { joins("LEFT JOIN games ON games.id = picks.game_id").where("games.round_id = ?", round_id) }

  def to_i
    self.id.to_i
  end

  # Gives number of points currently earned for a pick
  def points
    (self.correct?) ? (multiplier) : (0)
  end

  def current_possible_points
    (self.correct? || self.uncertain?) ? (multiplier) : (0)
  end

  # Gives number of possible points for a given pick (independent of actual outcome)
  def initial_possible_points
    multiplier
  end

  def multiplier
    round = self.game.round_id
    seed = self.team.seed
    2 ** (round-1) * seed
  end

  def correct?
    result == "right"
  end

  def uncertain?
    result.empty?
  end

end
