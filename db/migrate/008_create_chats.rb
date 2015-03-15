class CreateChats < ActiveRecord::Migration
  def change
    create_table :chats do |t|
      t.integer :elapsed
      t.references :match
      t.integer :client_id
      t.string :nickname
      t.text :message

      t.timestamps :null => false
    end
    add_index :chats, :match_id
  end
end
