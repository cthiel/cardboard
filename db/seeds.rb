# -*- encoding : utf-8 -*-
# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Mayor.create(:name => 'Daley', :city => cities.first)

Board.create({:name => 'CardBoard'}) if Board.count.eql?(0)

Deck.create([
  {:name => 'Backlog', :color => 'lightgrey', :board => Board.first},
  {:name => 'Work in progress', :color => 'yellow', :board => Board.first},
  {:name => 'Completed', :color => 'lightgreen', :board => Board.first},
])

welcome = <<EOS
Welcome to Cardboard!

Cardboard is a simple way to keep simple information in simple categories, and share it, simply. (We like simplicity).

Double-click on this card to edit it, or drag it into a different column.  Double-click the blank space in a column to create a new card.  The text uses [Markdown](http://daringfireball.net/projects/markdown/syntax), a super-simple way to add some **basic** _decoration_.  The first line is your title.  No fancy fields... just your notes on cards.

We're using it for kanban.  Feel free to use it to get those silly notes off your monitor. Or whatever :)

For more info about how cardboard works, check out the [project](https://github.com/cthiel/cardboard).
EOS

Card.create(
 {:name => welcome, :deck => Deck.first}
)
