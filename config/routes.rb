CardBoard::Application.routes.draw do
  resources :cards do
    collection { post :sort }
  end
  resources :decks
  resources :boards

  root :to => 'boards#index'
end
