Rails.application.routes.draw do
  devise_for :users

  root 'articles#index'

  # Main page
  get 'main/index'

  # Source example for module vendor/swamp/debug.rb    
  get 'source/index'

  # Information and notebook 
  get 'information/note'

  # Task page
  get 'task/index'
  
  resources :articles
  #resources :users
  get 'users/editcurrent'
  get '/users/:id', :to => 'users#editcurrent', :as => :user
  patch '/users/:id(.:format)', :to => 'users#update'
end
