Rails.application.routes.draw do
  devise_for :admins
  devise_for :users

  root "home#index"

  authenticate :admin do
    resources :transport_companies
  end

  authenticate :user do
    resources :carrier_vehicles
    resources :prices
    resources :delivery_times
  end

  resources :transport_companies do
    member do
      patch :toggle_status
    end
  end

  resources :work_orders do
    member do
      get :new_directly_assign
    end
    member do
      post :create_directly_assign
    end
    collection do
      get :search
    end
  end


  # resources :transport_companies, only: [:index, :show, :new, :create, :edit, :update]
  # resources :carrier_vehicles, only: [:index, :show, :new, :create, :edit, :update, :destroy]
  resources :work_orders, only: [:index, :show, :new, :create, :edit, :update, :destroy]

  # resources :prices, param: :slug
  # resources :delivery_times, param: :slug
end
