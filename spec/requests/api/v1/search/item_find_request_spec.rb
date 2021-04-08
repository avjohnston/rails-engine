require 'rails_helper'

RSpec.describe "Api::V1::Items::Search Show", type: :request do
  before :each do
    setup_five_merchants_revenue
  end

  describe 'happy path' do
    it 'when i search for an item by name only' do
      get api_v1_items_find_path, params: { name: 'item' }

      json = JSON.parse(response.body, symbolize_names: true)
      expect(response).to have_http_status(200)

      expect(json[:data].class).to eq(Hash)
      expect(json[:data][:type]).to eq('item')
      expect(json[:data][:attributes].class).to eq(Hash)
      expect(json[:data][:attributes][:name]).to eq("#{@item_1.name}")
      expect(json[:data][:attributes][:description]).to eq("#{@item_1.description}")
      expect(json[:data][:attributes][:unit_price]).to eq("#{@item_1.unit_price.to_f}")
      expect(json[:data][:attributes][:merchant_id]).to eq(@item_1.merchant_id)

      get api_v1_items_find_path, params: { name: '4' }

      json = JSON.parse(response.body, symbolize_names: true)
      expect(response).to have_http_status(200)
      expect(json[:data][:attributes][:name]).to eq("#{@item_4.name}")
      expect(json[:data][:attributes][:description]).to eq("#{@item_4.description}")
      expect(json[:data][:attributes][:unit_price]).to eq("#{@item_4.unit_price.to_f}")
      expect(json[:data][:attributes][:merchant_id]).to eq(@item_4.merchant_id)
    end

    it 'when i search for an item by min price only' do
      get api_v1_items_find_path, params: { min_price: 5 }

      json = JSON.parse(response.body, symbolize_names: true)
      expect(response).to have_http_status(200)

      expect(json[:data].class).to eq(Hash)
      expect(json[:data][:type]).to eq('item')
      expect(json[:data][:attributes].class).to eq(Hash)
      expect(json[:data][:attributes][:name]).to eq("#{@item_1.name}")
      expect(json[:data][:attributes][:description]).to eq("#{@item_1.description}")
      expect(json[:data][:attributes][:unit_price]).to eq("#{@item_1.unit_price.to_f}")
      expect(json[:data][:attributes][:merchant_id]).to eq(@item_1.merchant_id)

      get api_v1_items_find_path, params: { min_price: 20 }

      json = JSON.parse(response.body, symbolize_names: true)
      expect(response).to have_http_status(200)
      expect(json[:data][:attributes][:name]).to eq("#{@item_3.name}")
      expect(json[:data][:attributes][:description]).to eq("#{@item_3.description}")
      expect(json[:data][:attributes][:unit_price]).to eq("#{@item_3.unit_price.to_f}")
      expect(json[:data][:attributes][:merchant_id]).to eq(@item_3.merchant_id)
    end

    it 'when i search for an item by max price only' do
      get api_v1_items_find_path, params: { max_price: 10 }

      json = JSON.parse(response.body, symbolize_names: true)
      expect(response).to have_http_status(200)

      expect(json[:data].class).to eq(Hash)
      expect(json[:data][:type]).to eq('item')
      expect(json[:data][:attributes].class).to eq(Hash)
      expect(json[:data][:attributes][:name]).to eq("#{@item_1.name}")
      expect(json[:data][:attributes][:description]).to eq("#{@item_1.description}")
      expect(json[:data][:attributes][:unit_price]).to eq("#{@item_1.unit_price.to_f}")
      expect(json[:data][:attributes][:merchant_id]).to eq(@item_1.merchant_id)

      get api_v1_items_find_path, params: { max_price: 100 }

      json = JSON.parse(response.body, symbolize_names: true)
      expect(response).to have_http_status(200)

      expect(json[:data][:attributes][:name]).to eq("#{@item_1.name}")
      expect(json[:data][:attributes][:description]).to eq("#{@item_1.description}")
      expect(json[:data][:attributes][:unit_price]).to eq("#{@item_1.unit_price.to_f}")
      expect(json[:data][:attributes][:merchant_id]).to eq(@item_1.merchant_id)
    end

    it 'when i search for an item by min and max price only' do
      get api_v1_items_find_path, params: { min_price: 5, max_price: 10 }

      json = JSON.parse(response.body, symbolize_names: true)
      expect(response).to have_http_status(200)

      expect(json[:data].class).to eq(Hash)
      expect(json[:data][:type]).to eq('item')
      expect(json[:data][:attributes].class).to eq(Hash)
      expect(json[:data][:attributes][:name]).to eq("#{@item_1.name}")
      expect(json[:data][:attributes][:description]).to eq("#{@item_1.description}")
      expect(json[:data][:attributes][:unit_price]).to eq("#{@item_1.unit_price.to_f}")
      expect(json[:data][:attributes][:merchant_id]).to eq(@item_1.merchant_id)

      get api_v1_items_find_path, params: { min_price: 15, max_price: 25 }

      json = JSON.parse(response.body, symbolize_names: true)
      expect(response).to have_http_status(200)
      expect(json[:data][:attributes][:name]).to eq("#{@item_3.name}")
      expect(json[:data][:attributes][:description]).to eq("#{@item_3.description}")
      expect(json[:data][:attributes][:unit_price]).to eq("#{@item_3.unit_price.to_f}")
      expect(json[:data][:attributes][:merchant_id]).to eq(@item_3.merchant_id)
    end
  end

  describe 'sad path' do
    it 'when i search by name and price it returns empty hash' do
      get api_v1_items_find_path, params: { name: 'Item', max_price: 25 }

      json = JSON.parse(response.body, symbolize_names: true)
      expect(response).to have_http_status(400)
      expect(json[:data]).to eq({})

      get api_v1_items_find_path, params: { name: 'Item', min_price: 5 }

      json = JSON.parse(response.body, symbolize_names: true)
      expect(response).to have_http_status(400)
      expect(json[:data]).to eq({})

      get api_v1_items_find_path, params: { name: 'Item', min_price: 5, max_price: 25 }

      json = JSON.parse(response.body, symbolize_names: true)
      expect(response).to have_http_status(400)
      expect(json[:data]).to eq({})
    end

    it 'when i search for price less than 0' do
      get api_v1_items_find_path, params: { min_price: -25 }

      json = JSON.parse(response.body, symbolize_names: true)
      expect(response).to have_http_status(400)
      expect(json[:data]).to eq({})

      get api_v1_items_find_path, params: { max_price: -25 }

      json = JSON.parse(response.body, symbolize_names: true)
      expect(response).to have_http_status(400)
      expect(json[:data]).to eq({})

      get api_v1_items_find_path, params: { min_price: 5, max_price: -25 }

      json = JSON.parse(response.body, symbolize_names: true)
      expect(response).to have_http_status(400)
      expect(json[:data]).to eq({})

      get api_v1_items_find_path, params: { min_price: -5, max_price: -25 }

      json = JSON.parse(response.body, symbolize_names: true)
      expect(response).to have_http_status(400)
      expect(json[:data]).to eq({})

      get api_v1_items_find_path, params: { min_price: -35, max_price: -25 }

      json = JSON.parse(response.body, symbolize_names: true)
      expect(response).to have_http_status(400)
      expect(json[:data]).to eq({})
    end

    it 'when i search for price with no returns' do
      get api_v1_items_find_path, params: { min_price: 100000 }

      json = JSON.parse(response.body, symbolize_names: true)
      expect(response).to have_http_status(200)
      expect(json[:data]).to eq({})
    end

    it 'when min price is greater than max price' do
      get api_v1_items_find_path, params: { min_price: 50, max_price: 25 }

      json = JSON.parse(response.body, symbolize_names: true)
      expect(response).to have_http_status(400)
      expect(json[:data]).to eq({})
    end
  end
end
