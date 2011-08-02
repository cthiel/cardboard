class Status < ActiveRecord::Base
  validates :name, :presence => true, :uniqueness => true

  has_many :stories
  has_paper_trail
end
