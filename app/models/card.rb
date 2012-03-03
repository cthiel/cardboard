# == Schema Information
#
# Table name: cards
#
#  id         :integer         not null, primary key
#  name       :text
#  created_at :datetime
#  updated_at :datetime
#  deck_id    :integer
#  position   :integer
#

class Card < ActiveRecord::Base
  validates :name, :presence => true, :uniqueness => true
  validates :deck, :presence => true, :associated => true
  validates :position, :numericality => true
    
  acts_as_taggable_on :tags
  acts_as_list

  belongs_to :deck
  has_paper_trail

  default_scope order("position")
end
