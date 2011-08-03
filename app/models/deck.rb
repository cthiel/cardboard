class Deck < ActiveRecord::Base
  before_validation :position_last_if_null
  validates :name, :presence => true, :uniqueness => true
  validates :board, :presence => true, :associated => true
  validates :position, :numericality => true
  
  belongs_to :board
  has_many :cards
  has_paper_trail
  acts_as_list :scope => :board
  
  default_scope order("position")

  protected
  
  def position_last_if_null
    unless self.position
      self.position = Deck.count + 1
    end 
  end  
end
