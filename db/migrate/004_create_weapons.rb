class CreateWeapons < ActiveRecord::Migration
  def change
    create_table :weapons do |t|
      t.string :weapon

      t.timestamps :null => false
    end
  end
end
