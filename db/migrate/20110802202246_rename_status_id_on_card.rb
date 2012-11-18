# -*- encoding : utf-8 -*-
class RenameStatusIdOnCard < ActiveRecord::Migration
  def up
    rename_column :cards, :status_id, :deck_id
  end

  def down
    rename_column :cards, :deck_id, :status_id
  end
end
