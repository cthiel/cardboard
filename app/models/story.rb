class Story < ActiveRecord::Base
  validates :number, :presence => true, :uniqueness => true 
  validates :name, :presence => true, :uniqueness => true
  validates :status, :presence => true, :associated => true
  
  acts_as_taggable_on :tags

  belongs_to :status

  def status_code
    status.code
  end
end
