class CreateScores < ActiveRecord::Migration
  def change
    create_table :scores do |t|
      t.integer :elapsed
      t.references :match
      t.integer :killer_id
      t.integer :killed_id
      t.references :weapon

      t.timestamps :null => false
    end
    add_index :scores, :match_id
    add_index :scores, :weapon_id
  end
end
