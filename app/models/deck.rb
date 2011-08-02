class Deck < ActiveRecord::Base
  validates :name, :presence => true, :uniqueness => true

  has_many :cards
  has_paper_trail
end
