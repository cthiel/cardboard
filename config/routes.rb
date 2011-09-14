CardBoard::Application.routes.draw do
  resources :cards
  resources :decks do
    put :sort
  end
  resources :boards

  if ["development", "test"].include? Rails.env
    mount Jasminerice::Engine => "/jasmine" 
  end

  root :to => 'boards#index'
end
