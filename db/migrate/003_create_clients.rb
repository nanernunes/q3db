class CreateClients < ActiveRecord::Migration
  def change
    create_table :clients do |t|
      t.integer :elapsed
      t.references :match
      t.integer :session_id
      t.string :nickname
      t.string :model

      t.timestamps
    end
    add_index :clients, :match_id
  end
end
