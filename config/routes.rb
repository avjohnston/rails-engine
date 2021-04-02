Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      resources :merchants, only: [:index, :show]
      resources :items
    end
  end

  delete '/api/v1/items', to: 'api/v1/items#destroy'

  get '/api/v1/merchants/:id/items', to: 'api/v1/merchants/merchant_items#index'
  get '/api/v1/items/:id/merchant', to: 'api/v1/items#item_merchant'
end
