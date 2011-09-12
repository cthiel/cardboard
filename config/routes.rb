CardBoard::Application.routes.draw do
  resources :cards
  resources :decks
  resources :boards

  if ["development", "test"].include? Rails.env
    mount Jasminerice::Engine => "/jasmine" 
  end

  root :to => 'boards#index'
end
