class Deck < ActiveRecord::Base
  validates :name, :presence => true, :uniqueness => true

  has_many :cards
  has_paper_trail
  acts_as_list
  
  default_scope order("position")
end
