class CreateBrackets < ActiveRecord::Migration
  def change
    create_table :brackets do |t|
      t.integer :group_id
      t.string :name
      t.string :link
      t.timestamps null: false
    end
  end
end
