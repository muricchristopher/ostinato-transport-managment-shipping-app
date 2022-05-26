Rails.application.routes.draw do
  devise_for :admins
  devise_for :users

  root "home#index"

  authenticate :admin do
    resources :transport_companies
  end

  authenticate :user do
    resources :carrier_vehicles
  end

  resources :transport_companies do
    member do
      patch :toggle_status
    end
  end




  resources :transport_companies, only: [:index, :show, :new, :create, :edit, :update]
  resources :carrier_vehicles, only: [:index, :show, :new, :create, :edit, :update, :destroy]
  resources :prices, only: [:index, :new, :create, :edit, :update, :destroy]
end
