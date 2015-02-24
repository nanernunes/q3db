class Match < ActiveRecord::Base
  has_many :chats
  has_many :scores
  has_many :clients
  has_many :supplies
end
