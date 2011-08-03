class Board < ActiveRecord::Base
  validates :name, :presence => true, :uniqueness => true
  
  has_many :decks
end
