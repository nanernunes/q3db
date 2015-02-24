class CreateStats < ActiveRecord::Migration
  def change
    create_table :stats do |t|
      t.string :nickname
      t.integer :matches,  default: 0
      t.integer :winnings, default: 0
      t.integer :defeats,  default: 0
      t.integer :absence

      t.timestamps :null => false
    end
  end
end
