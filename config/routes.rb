Rails.application.routes.draw do

  get 'test' => 'test#index'
  get 'scanner/book_record' => 'books#record', as: 'book_record'

  resources :book_infos
  resources :books do
    collection do
      get 'sniffer'
      get 'jd_get_isbn'
      get 'new_by_isbn/:isbn' => 'books#new_by_isbn'
      post 'create_by_scan'
      post 'borrow_by_isbn'
      post 'ret'
      post 'favor'
    end
  end
  # You can have the root of your site routed with "root"
  root 'main#index'
  get 'main/index'
  get 'main/chat'

  resources :users do
    get 'record_books'
    get 'record_books/socket' => 'users#record_books_socket'
    collection do
      get 'access_token'
    end
  end

  get 'login', to: "user/session#new", as: 'login'
  get 's/:token', to: "user/session#create_by_token", as: 'token_login'
  
  namespace :user do
    post 'sessions', to: 'session#create', as: :sessions
    get 'session/destroy'
  end


  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".



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
