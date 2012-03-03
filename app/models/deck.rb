# == Schema Information
#
# Table name: decks
#
#  id         :integer         not null, primary key
#  name       :string(255)
#  color      :string(255)
#  created_at :datetime
#  updated_at :datetime
#  position   :integer
#  board_id   :integer
#

class Deck < ActiveRecord::Base
  validates :name, :presence => true, :uniqueness => true
  validates :board, :presence => true, :associated => true
  validates :position, :numericality => true
  
  belongs_to :board
  has_many :cards
  has_paper_trail
  acts_as_list :scope => :board
  
  default_scope order("position")
end
