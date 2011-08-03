CardBoard::Application.routes.draw do
  resources :cards
  resources :decks
  resources :boards

  root :to => 'boards#index'
end
