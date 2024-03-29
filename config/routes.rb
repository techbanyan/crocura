Crocura::Application.routes.draw do

  mount Rich::Engine => '/rich', :as => 'rich'

  ActiveAdmin.routes(self)

  devise_for :admin_users, ActiveAdmin::Devise.config

  match "/auth/:provider/callback" => "sessions#create"
  match "/signout" => "sessions#destroy", :as => :signout

  match "how_it_works" =>  "header_links#how_it_works"
  match "faq" =>  "header_links#faq"
  match "help" =>  "header_links#help"
  match "about" =>  "header_links#about"
  match "privacy" => "header_links#privacy"

  match "stream" => "welcome#stream"
  match "stream_container" => "welcome#stream_container"

  match "search" => "search#search"
  match "search_stream_container" => "search#search_stream_container"

  match "users_stream" => "users#users_stream"
  match "users_stream_container" => "users#users_stream_container"

  match "profile_stream" => "profile#profile_stream"
  match "profile_stream_container" => "profile#profile_stream_container"

  match "photos/comment" => "photos#comment"
  match "photos/like" => "photos#like"
  match "photos/get_all_likes" => "photos#get_all_likes"
  match "photos/get_all_comments" => "photos#get_all_comments"

  resources :photos
  resources :users

  match "unfollow_user" => "users#unfollow_user"
  match "follow_user" => "users#follow_user"

  match "profile" => "profile#show"

  match '/:id' => 'users#show', :as => :user # NOTE - this should always be last

  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
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

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  
  root :to => 'welcome#index'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id))(.:format)'
end
