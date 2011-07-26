class RemoveStatusCodeFromStory < ActiveRecord::Migration
  def self.up
    remove_column :stories, :status_code
  end

  def self.down
    add_column :stories, :status_code, :string
  end
end
