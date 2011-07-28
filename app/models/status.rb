class Status < ActiveRecord::Base
  validates :code, :presence => true, :uniqueness => true
  validates :name, :presence => true, :uniqueness => true

  has_many :stories
end
