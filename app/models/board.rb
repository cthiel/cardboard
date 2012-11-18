# -*- encoding : utf-8 -*-
# == Schema Information
#
# Table name: boards
#
#  id         :integer         not null, primary key
#  name       :string(255)
#  created_at :datetime
#  updated_at :datetime
#  slug       :string(255)
#

class Board < ActiveRecord::Base
  extend FriendlyId
  friendly_id :name, :use => :slugged
  
  has_many :decks
end
