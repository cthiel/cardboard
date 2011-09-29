# CardBoard

A simple web-based card grouping application with a bit of 
collaboration, based on Rails 3.1.0.rc5

It's designed to be flexible! Use it for organizing tasks,
Kanban, card sorting, or tracking anything.

## Demo

Visit http://card-board.herokuapp.com/ to try it out right away!

## Installation instructions

    git clone git://github.com/cthiel/cardboard.git
    cd cardboard
    sudo gem install bundler
    bundle install --without production
    rake db:setup
    rails server

Visit http://localhost:3000/ and you should see your cardboard!

Run your own instance of CardBoard on Heroku: https://github.com/cthiel/cardboard/wiki/Setting-up-CardBoard-on-Heroku

## Updating

Updating is similar to installation. If `rake db:migrate`
triggers changes, you'll have to restart your Rails server!

    git pull
    bundle install --without production
    rake db:migrate
    rails server  # if there were DB migrations, restart

(Most of the time you won't have to do much more than 
`git pull`, unless the required gems or DB schema changes.)

## Thanks

This project was inspired by http://www.simple-kanban.com/ 
and https://github.com/0s30s1s/simplekanban

## Team

* Christoph Thiel (@cthiel)
* Garrett LeSage (@garrett)
* James Mason (@bear454)
