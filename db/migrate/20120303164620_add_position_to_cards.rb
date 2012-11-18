# -*- encoding : utf-8 -*-
class AddPositionToCards < ActiveRecord::Migration
  def up
    add_column :cards, :position, :integer
    add_index :cards, :position

    Card.reset_column_information
    Card.all.each do |deck|
      deck.update_attribute(:position, card.id)
    end
  end

  def down
    remove_index :cards, :position
    remove_column :cards, :position, :integer
  end
end
