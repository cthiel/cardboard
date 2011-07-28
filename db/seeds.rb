# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Mayor.create(:name => 'Daley', :city => cities.first)

Status.create([
  {:code => 'P_Q', :name => 'ProductMgmt Ready'},
  {:code => 'P', :name => 'ProductMgmt'},
  {:code => 'C_Q', :name => 'Design Ready'},
  {:code => 'C', :name => 'Design'},
  {:code => 'D_Q', :name => 'Development Ready'},
  {:code => 'D', :name => 'Development'},
  {:code => 'T_Q', :name => 'Test Ready'},
  {:code => 'T', :name => 'Test'},
  {:code => 'R_Q', :name => 'Release Ready'},
  {:code => 'R', :name => 'Release'},
])
