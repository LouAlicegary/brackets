class CreateTeams < ActiveRecord::Migration
  def change
    create_table :teams do |t|
      t.string :abbr
      t.string :name
      t.integer :cbs_id
      t.integer :seed
      t.timestamps null: false
    end
  end
end
