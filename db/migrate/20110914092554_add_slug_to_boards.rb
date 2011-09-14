class AddSlugToBoards < ActiveRecord::Migration
  def change
    add_column :boards, :slug, :string
    add_index :boards, :slug, :unique => true

    Board.reset_column_information
    Board.all.map(&:save)
  end
end
