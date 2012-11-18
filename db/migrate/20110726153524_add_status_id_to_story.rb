# -*- encoding : utf-8 -*-
class AddStatusIdToStory < ActiveRecord::Migration
  def self.up
    add_column :stories, :status_id, :integer
  end

  def self.down
    remove_column :stories, :status_id
  end
end
