Rails.application.routes.draw do
  get '/api/get_braintree_token', to: 'custom_brain_trees#get_braintree_token', defaults: {format: :json}
  get '/api/get_currency_based_on_country_code', to: 'currencies#get_currency_based_on_country_code'
  put '/api/luxire_product_type/update_with_position/:id', to: 'luxire_product_types#update_with_position', defaults: {format: :json}
  post '/api/luxire_product_type/create_with_position', to: 'luxire_product_types#create_with_position', defaults: {format: :json}
  put '/api/update_order_currency', to: 'currencies#update_order_currency'
  resources :luxire_taxonomies
  resources :luxire_style_master_images
  put 'api/change_order_status', to: 'custom_orders#change_order_status', defaults: {format: :json}
  get '/api/admin/products' => 'spree/api/products#admin_index'
  get '/api/admin/products/:id' => 'spree/api/products#admin_show'
  post '/my_account/old_order', to: 'luxire_user_my_account#old_order',  defaults: {format: :json}

  get 'template_field_finder/abandoned_checkouts', defaults: {format: :json}

  get 'template_field_finder/contact_customer', defaults: {format: :json}

  get 'template_field_finder/customer_account_invite', defaults: {format: :json}

  get 'template_field_finder/customer_account_welcome', defaults: {format: :json}

  get 'template_field_finder/customer_account_password_reset', defaults: {format: :json}

  get 'template_field_finder/draft_order_invoice', defaults: {format: :json}

  get 'template_field_finder/fulfilment_request', defaults: {format: :json}

  get 'template_field_finder/gift_cards_created', defaults: {format: :json}

  get 'template_field_finder/new_order', defaults: {format: :json}

  get 'template_field_finder/order_cancelled', defaults: {format: :json}

  get 'template_field_finder/order_confirmation', defaults: {format: :json}

  get 'template_field_finder/order_refund', defaults: {format: :json}

  get 'template_field_finder/shipping_confirmation', defaults: {format: :json}

  get 'template_field_finder/shipping_update', defaults: {format: :json}

   put 'api/checkouts/apply_gift_code', to: 'spree/api/orders#apply_gift_code',  defaults: {format: :json}
   get 'api/admin/products',to: 'spree/api/products#admin_index'
   get 'api/admin/products/:id',to: 'spree/api/products#admin_show'

  resources :standard_sizes, defaults: {format: :json}
  get 'get_customer_attr',to: 'retrive_attribute_info#get_customer_attr'
  get 'get_order_attr',to: 'retrive_attribute_info#get_order_attr'
  get 'get_shipping_attr',to: 'retrive_attribute_info#get_shipping_attr'
  resources :mail_templates,  defaults: {format: :json}
  get 'customized_taxons/get_taxon_details'

  resources :luxire_properties, defaults: {format: :json}
  resources :custom_images, defaults: {format: :json}
  post 'populate_currency', to: 'currencies#populate_currency'
  get 'get_currency_multiplier', to: 'currencies#get_currency_multiplier'
  get 'get_standard_size', to: 'standard_sizes#get_standard_size', defaults: {format: :json}
  resources :currencies, defaults: {format: :json}
# routing for customized taxon controller
  resources :taxonomies, defaults: {format: :json} do
    collection do
      post :update_positions
    end
    resources :customized_taxons
  end

  resources :customized_taxons, only: [:index, :show], defaults: {format: :json} do
    collection do
      get :search
    end
  end

  resources :customized_images, defaults: {format: :json}

  resources :measurement_type_prototypes, defaults: {format: :json}
  get 'get_order', to: 'custom_orders#get_order', defaults: {format: :json}
  post 'luxire_product_data/imports', to: 'luxire_product_data_imports#import', as: :luxire_product_data_imports
  get 'luxire_product_data_imports', to: 'luxire_product_data_imports#index'
  post '/my_account', to: 'luxire_user_my_account#index',  defaults: {format: :json}
  get '/my_account/:id', to: 'luxire_user_my_account#show',  defaults: {format: :json}
  post 'receive_ebs_responses/ebs_response'
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
    resources :luxire_product_type_style_masters

  # This line mounts Spree's routes at the root of your application.
  # This means, any requests to URLs such as /products, will go to Spree::ProductsController.
  # If you would like to change where this engine is mounted, simply change the :at option to something different.
  #
  # We ask that you don't use the :as option here, as Spree relies on it being the default of "spree"
  mount Spree::Core::Engine, :at => '/'


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
