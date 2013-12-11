class CreateChats < ActiveRecord::Migration
  def change
    create_table :chats do |t|
      t.integer :elapsed
      t.references :match
      t.string :nickname
      t.text :message

      t.timestamps
    end
    add_index :chats, :match_id
  end
end
