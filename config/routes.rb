CardBoard::Application.routes.draw do

  resources :boards do
    resources :decks do
      put :sort
    end
    resources :cards
  end

  if ["development", "test"].include? Rails.env
    mount Jasminerice::Engine => "/jasmine" 
  end

  match '/:id' => 'boards#show'

  root :to => 'boards#show'
end
