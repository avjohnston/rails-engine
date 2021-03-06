Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      get 'merchants/find', to: 'merchants/search#show'
      get 'merchants/:id/items', to: 'merchants/merchant_items#index', as: 'merchant_items'
      get 'items/find_all', to: 'items/search#index'
      get 'items/find', to: 'items/search#show'
      get 'items/:id/merchant', to: 'items#item_merchant', as: 'items_merchant'
      get 'revenue/merchants', to: 'revenue/merchants#index'
      get 'revenue/merchants/:id', to: 'revenue/merchants#show', as: 'merchant_revenue_show'
      get '/revenue/items', to: 'revenue/items#index'
      get 'merchants/most_items', to: 'merchants/most_items#index'
      resources :merchants, only: %i[index show]
      resources :items
    end
  end
end
