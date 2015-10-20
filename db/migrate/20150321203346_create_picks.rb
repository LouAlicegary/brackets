class CreatePicks < ActiveRecord::Migration
  def change
    create_table :picks do |t|
      t.integer :bracket_id
      t.integer :game_id
      t.integer :team_id
      t.string :result
      t.timestamps null: false
    end
  end
end
