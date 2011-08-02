# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Mayor.create(:name => 'Daley', :city => cities.first)

Status.create([
  {:name => 'Backlog', :color => 'lightgrey'},
  {:name => 'Work in progress', :color => 'yellow'},
  {:name => 'Completed', :color => 'lightgreen'},
])
Story.create(
 {:name => "Your first card.", :status_id => Status.first.id}
)
