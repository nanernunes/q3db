class Score < ActiveRecord::Base
  belongs_to :weapon
  belongs_to :killer, class_name: :client.capitalize, foreign_key: :killer_id
  belongs_to :killed, class_name: :client.capitalize, foreign_key: :killed_id
end
