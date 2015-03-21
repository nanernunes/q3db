class CreateStats < ActiveRecord::Migration
  def change
    create_table :stats do |t|
      t.string   :nickname
      t.integer  :matches,  default: 0
      t.integer  :frags,    default: 0
      t.integer  :kills,    default: 0
      t.integer  :absence

      t.timestamps :null => false
    end
  end
end
