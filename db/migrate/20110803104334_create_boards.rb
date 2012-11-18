class CreateBoards < ActiveRecord::Migration
  def change
    create_table :boards do |t|
      t.string :name

      t.timestamps
    end

    #Board.reset_column_information  
    #Board.create({:name => 'CardBoard'})
  end
end
