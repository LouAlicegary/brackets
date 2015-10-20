class Bracket < ActiveRecord::Base


  has_many :picks


  def show_stats
    show_total_stats
    puts "\n\n"
    (1..6).each do |round_id|
      show_stats_by_round round_id
      puts "\n\n"
    end
  end

  def current_score round_id = nil
    total_points = 0
    if round_id.nil?
      (1..6).each do |r| 
        self.picks.all.round(r).right.each { |p| total_points += p.points }
      end
    else
      self.picks.all.round(round_id).right.each { |p| total_points += p.points }
    end
    total_points
  end

  def current_possible_score round_id = nil
    total_points = 0
    if round_id.nil?
      (1..6).each do |r| 
        self.picks.all.round(r).each { |p| total_points += p.current_possible_points }
      end
    else
      self.picks.all.round(round_id).each { |p| total_points += p.current_possible_points }
    end
    total_points
  end

  def show_total_stats
    number_correct
    number_incorrect
    number_eliminated
    number_uncertain
    current_score
    current_possible_score
  end

  def show_stats_by_round round_id
    number_correct round_id
    number_incorrect round_id
    number_eliminated round_id
    number_uncertain round_id
    current_score round_id
    current_possible_score round_id  
  end

  def number_correct round_id = nil
    pick_count = self.picks.all.right.count if round_id.nil?
    pick_count = self.picks.all.round(round_id).right.count unless round_id.nil?
    pick_count 
  end

  def number_incorrect round_id = nil
    pick_count = self.picks.all.wrong.count if round_id.nil? 
    pick_count = self.picks.all.round(round_id).wrong.count unless round_id.nil?    
    pick_count 
  end

  def number_eliminated round_id = nil
    pick_count = self.picks.all.eliminated.count if round_id.nil? 
    pick_count = self.picks.all.round(round_id).eliminated.count unless round_id.nil?    
    pick_count 
  end

  def number_uncertain round_id = nil
    pick_count = self.picks.all.uncertain.count if round_id.nil? 
    pick_count = self.picks.all.round(round_id).uncertain.count unless round_id.nil?
    pick_count   
  end




end
