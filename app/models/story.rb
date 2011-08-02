class Story < ActiveRecord::Base
  validates :name, :presence => true, :uniqueness => true
  validates :status, :presence => true, :associated => true
  
  acts_as_taggable_on :tags

  belongs_to :status
end
