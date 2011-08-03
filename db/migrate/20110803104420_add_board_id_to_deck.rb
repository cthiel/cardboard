class AddBoardIdToDeck < ActiveRecord::Migration
  def change
    add_column :decks, :board_id, :integer

    Deck.reset_column_information  
    Deck.all.each do |deck|
      deck.update_attribute(:board_id, 1)
    end
  end
end
