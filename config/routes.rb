Rails.application.routes.draw do
    # Main page
    root 'main#index'
    get 'main/index'

    # Source example for module vendor/swamp/debug.rb    
    get 'source/index'

    # Information and notebook 
    get 'information/note'

    # Task page
    get 'task/index'
end
