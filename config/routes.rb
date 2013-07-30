Wcsf::Application.routes.draw do

  get "services/index"

  get "services_controller/index"

  namespace :admin do
    root to: 'admin#index'
    resources :donors
    resources :students
  end

  resources :school_activities


  resources :school_classes
  resources :global_badges
  match '/progress', to: 'global_badges#progress'
  match '/global_badges/semester', to: 'global_badges#SemesterBadges'

  devise_for :users, :controllers => {:registrations => "registrations"}

  root :to => 'static_pages#home'
  get '/what_is_wcsf', to: 'static_pages#what_is_wcsf'
  get '/students', to: 'static_pages#students'
  get '/staff', to: 'static_pages#staff'
  get '/donors', to: 'static_pages#donors'
  get '/apply', to: 'static_pages#apply'
  get '/donate', to: 'static_pages#donate'
  get '/partnerships', to: 'static_pages#partnerships'
  get '/calendar', to: 'static_pages#calendar'

  get '/contact', to: 'contacts#index', as: 'contact'
  resources :contacts, only: [:index, :create]


  match '/profile', to: 'static_pages#profile'
  match '/summary', to: 'static_pages#summary'

  match '/academics', to: 'academics#index'
  match '/saveClasses', to: 'academics#saveClasses'

  match '/activities', to: 'activities#index'
  match '/saveActivities', to: 'activities#saveActivities'

  match '/services', to: 'services#index'
  match '/saveServices', to: 'services#saveServices'

  match '/mybadges', to: 'my_badges#index'
  match '/updateGrid', to: 'my_badges#updateGrid'

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
  root :to => 'static_pages#home'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id))(.:format)'
end
