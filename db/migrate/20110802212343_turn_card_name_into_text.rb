# -*- encoding : utf-8 -*-
class TurnCardNameIntoText < ActiveRecord::Migration
  def up
    change_column :cards, :name, :text, :limit => nil
  end

  def down
    change_column :cards, :name, :string
  end
end
