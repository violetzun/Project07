Project07::Application.routes.draw do


  mount RedactorRails::Engine => '/redactor_rails'
  resources :movies


  resources :entries do
    resource :comments
    resource :movies
  end

  devise_for :users

get "projects/documentation"
get "projects/error"
get "projects/quotations"
get "projects/pgdump"
get "projects/trendingNow"
get "projects/search"





get "list_of_users" => "user#index"

match '/list_of_users' => "user#bann", :via => :post

get "home" => "entries#index", :as => "home"
get "review" => "entries#review", :as => "review"
get "profile" => "entries#profile", :as => "profile"
match '/profile' => 'entries#profile', :via => :post
get "render_pic" => "entries#render_pic", :as => "render_pic"
match "render_pic" => "entries#uploadFile", :via => :post
# match 'users' => "user#bann" , :via => :post
get "recommend" => "movies#recommend", :as => "recommend"
get "searchMovie" => "entries#searchMovie", :as => "searchMovie"

get "timeline" => "entries#timeline", :as => "timeline"






  #:collection => { :edit_multiple => :post, :update_multiple => :put
match '/projects/quotations' => 'projects#quotations', :via => :post
match '/projects/quotations' => 'projects#export_file', :via => :post
match '/projects/quotations' => 'projects#cookie_setup', :via => :post
match 'entries/newComment' => 'entries#newComment', :via => :post
match 'searchMovie' => 'entries#searchMovie', :via => :post


#match 'entries/doLike' => 'entries#doLike', :via => :post
#match 'movies/doLike' => 'movies#doLike', :via => :post


get '/auth/:provider/callback', to: 'authentication#create'

  resources :projects do
	resources :solutions

  resources :quotations


end
root :to => "projects#index"

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end
  
  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
