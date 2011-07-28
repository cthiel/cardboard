class RemoveNumberFromStory < ActiveRecord::Migration
  def up
    remove_column :stories, :number
  end

  def down
    add_column :stories, :number, :string
  end
end
