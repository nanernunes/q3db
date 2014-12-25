class CreateCommits < ActiveRecord::Migration
  def change
    create_table :commits do |t|
      t.integer :fsize
      t.integer :mtime

      t.timestamps :null => false
    end
  end
end
