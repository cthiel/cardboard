CardBoard::Application.routes.draw do
  resources :cards
  resources :decks
  resources :boards, :only => [:show], :requirement => {:id => 'default'}

  root :to => 'boards#show', :id => 'default'
end
