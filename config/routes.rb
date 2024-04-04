Rails.application.routes.draw do
resources :categories

resources :articles do
resources :comments, only: [:create, :destroy, :update]
end

devise_for :users

##Begin
##GET       /articles index
##POST      /articles create
##DELETE    /articles/:id destroy
##GET       /articles/:id show
##GET       /articles/new new
##GET       /articles/:id/edit  edit
##PATCH      /articles/:id  update
##PUT      /articles/:id  update

##end

  ##get 'welcome/index'
root 'welcome#index'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
get "/dashboard", to: "welcome#dashboard"
#get 'dashboard' => 'welcome#dashboard'

put "/articles/:id/publish", to: "articles#publish"
end
