class CreateSupplies < ActiveRecord::Migration
  def change
    create_table :supplies do |t|
      t.integer :elapsed
      t.references :match
      t.references :client
      t.references :item

      t.timestamps :null => false
    end
    add_index :supplies, :match_id
    add_index :supplies, :client_id
    add_index :supplies, :item_id
  end
end
