class AddPositionToDecks < ActiveRecord::Migration
  
  def up
    add_column :decks, :position, :integer
  
    Deck.reset_column_information  
    Deck.all.each do |deck|
      deck.update_attribute(:position, deck.id)
    end
    add_index :decks, :position
    
  end
  
  def down
    remove_index :decks, :position
    remove_column :decks, :position, :integer
  end
end
