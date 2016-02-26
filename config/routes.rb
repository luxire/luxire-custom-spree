Rails.application.routes.draw do

  resources :measurement_type_prototypes
  get 'get_order', to: 'custom_orders#get_order', defaults: {format: :json}
  post 'luxire_product_data/imports', to: 'luxire_product_data_imports#import', as: :luxire_product_data_imports
  get 'luxire_product_data_imports', to: 'luxire_product_data_imports#index'
  post '/my_account', to: 'luxire_user_my_account#index',  defaults: {format: :json}
  get '/my_account/:id', to: 'luxire_user_my_account#show',  defaults: {format: :json}
  # post 'receive_ebs_responses/ebs_response'
  post 'luxire_stocks/validate_stocks_sku', to: 'luxire_stocks#validate_stocks_sku',  defaults: {format: :json}
  post 'luxire_stocks/set_stocks',  defaults: {format: :json}
  post 'luxire_stocks/add_stocks',  defaults: {format: :json}

  resources :luxire_stocks, defaults: {format: :json}
  resources :product_measurement_types,  defaults: {format: :json}
  resources :measurement_types,  defaults: {format: :json}
  resources :luxire_product_types,  defaults: {format: :json}
  resources :luxire_style_masters,  defaults: {format: :json}
  resources :luxire_vendor_masters,  defaults: {format: :json}


  resources :customized_active_shipping_settings, defaults: {format: :json}
  resources :customized_shipping_methods, defaults: {format: :json}

  resources :customized_promotions, defaults: {format: :json} do
    resources :customized_promotion_rules
    resources :customized_promotion_actions
  end

  resources :customized_tax_rates, defaults: {format: :json}
  resources :customized_tax_categories, defaults: {format: :json}

  get '/api/countries/all' => 'spree/api/countries#allCountries'

  post 'search/get_all_data', defaults: {format: :json}

  #Routes for user management
  get '/luxire-users' => 'luxire_users#index'
  get '/luxire-users/:role' => 'luxire_users#usersByRole'
  get '/luxire-users/:id' => 'luxire_users#show'
  post '/luxire-users/login' => 'luxire_users#login'
  post '/luxire-users/signup' => 'luxire_users#signup'
  put '/luxire-users/:id/edit' => 'luxire_users#update'
  put '/luxire-users/:id/edit/change_password' => 'luxire_users#change_password'
  delete '/luxire-users/:id' => 'luxire_users#delete'
  post '/luxire-users/forgot_password' => 'luxire_users#forgot_password'
  get '/password_reset/:token' => 'luxire_users#reset_password_token_validation'
  post '/password_reset/:token' => 'luxire_users#change_password_with_reset_token'

  # This line mounts Spree's routes at the root of your application.
  # This means, any requests to URLs such as /products, will go to Spree::ProductsController.
  # If you would like to change where this engine is mounted, simply change the :at option to something different.
  #
  # We ask that you don't use the :as option here, as Spree relies on it being the default of "spree"
  mount Spree::Core::Engine, :at => '/'
          resources :luxire_product_type_style_masters

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
