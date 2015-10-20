class CreateGames < ActiveRecord::Migration
  def change
    create_table :games do |t|
      t.integer :cbs_id
      t.integer :round_id
      t.datetime :game_date
      t.string :region
      t.string :html_id
      t.string :html_id_next
      t.string :next_round_placement_for_pick
      t.integer :home_team_id
      t.integer :away_team_id
      t.integer :winner_id
      t.timestamps null: false
    end
  end
end
