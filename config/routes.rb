Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      get 'merchants/find', to: 'merchants/search#show'
      get 'merchants/:id/items', to: 'merchants/merchant_items#index', as: 'merchant_items'
      get 'items/find_all', to: 'items/search#index'
      get 'items/:id/merchant', to: 'items#item_merchant', as: 'items_merchant'
      resources :merchants, only: [:index, :show]
      resources :items
    end
  end
end
