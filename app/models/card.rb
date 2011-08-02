class Card < ActiveRecord::Base
  validates :name, :presence => true, :uniqueness => true
  validates :deck, :presence => true, :associated => true
  
  acts_as_taggable_on :tags

  belongs_to :deck
  has_paper_trail
end
