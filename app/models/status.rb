class Status < ActiveRecord::Base
  validates :code, :presence => true, :uniqueness => true
  validates :name, :presence => true, :uniqueness => true

  has_many :stories

  after_create :create_ready_status

private

  def create_ready_status
    unless self.code.include?('_Q')
      Status.create!(:name => self.name + " Ready", :code => self.code + "_Q", :color => '#F0F0F0')
    end
  end  
end
