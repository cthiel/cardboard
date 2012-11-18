# -*- encoding : utf-8 -*-
class Renaming < ActiveRecord::Migration
  def up
    rename_table :statuses, :decks
    rename_table :stories, :cards
  end

  def down
    rename_table :decks, :statuses
    rename_table :cards, :stories
  end
end
