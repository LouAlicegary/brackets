class CreateGroups < ActiveRecord::Migration
  def change
    create_table :groups do |t|
      t.string :name
      t.string :scoring_type
      t.integer :round_1_weight
      t.integer :round_2_weight
      t.integer :round_3_weight
      t.integer :round_4_weight
      t.integer :round_5_weight
      t.integer :round_6_weight                        
      t.timestamps    
    end
  end
end
