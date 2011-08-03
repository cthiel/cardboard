class Deck < ActiveRecord::Base
  validates :name, :presence => true, :uniqueness => true
  validates :board, :presence => true, :associated => true
  
  belongs_to :board
  has_many :cards
  has_paper_trail
  acts_as_list
  
  default_scope order("position")
end
