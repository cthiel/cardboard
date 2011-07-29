# SimpleKanban (fork)

A Kanban Board Application based on Rails 3.1.0.rc5

## Demo

Visit http://simplekanban-cthiel.herokuapp.com/ to try it out right away!

## Installation instructions

    sudo gem install bundler
    bundle install --without production
    rake db:migrate
    rake db:seed     # to seed database with sample status columns
    rails server

Visit http://localhost:3000/ and you should see your Kanban board!

## Thanks

This project was inspired by http://www.simple-kanban.com/ and https://github.com/0s30s1s/simplekanban


## Authors

* Christoph Thiel
* Garrett LeSage