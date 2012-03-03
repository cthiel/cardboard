CardBoard::Application.routes.draw do
  resources :cards
  resources :decks do
    put :sort
  end
  resources :boards

  root :to => 'boards#index'
end
