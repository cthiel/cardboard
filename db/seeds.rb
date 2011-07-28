# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Mayor.create(:name => 'Daley', :city => cities.first)

Status.create([
  {:code => 'P_Q', :name => 'ProductMgmt Ready', :color => 'lightgrey'},
  {:code => 'P', :name => 'ProductMgmt', :color => 'red'},
  {:code => 'C_Q', :name => 'Design Ready', :color => 'lightgrey'},
  {:code => 'C', :name => 'Design', :color => 'yellow'},
  {:code => 'D_Q', :name => 'Development Ready', :color => 'lightgrey'},
  {:code => 'D', :name => 'Development', :color => 'skyblue'},
  {:code => 'T_Q', :name => 'Test Ready', :color => 'lightgrey'},
  {:code => 'T', :name => 'Test', :color => 'orange'},
  {:code => 'R_Q', :name => 'Release Ready', :color => 'lightgrey'},
  {:code => 'R', :name => 'Release', :color => 'green'},
])
