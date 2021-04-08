require 'rails_helper'

RSpec.describe 'Api::V1::Revenue::Items', type: :request do
  before :each do
    setup_five_merchants_revenue
  end

  describe 'when i search for a given quantity of items with the most revenue' do
    it 'my information comes back in the correct format' do
      get api_v1_revenue_items_path, params: { quantity: 5 }

      json = JSON.parse(response.body, symbolize_names: true)
      expect(response).to have_http_status(200)

      expect(json[:data].class).to eq(Array)
      expect(json[:data].size).to eq(5)
      expect(json[:data][0][:type]).to eq('item_revenue')
      expect(json[:data][0][:attributes][:name]).to eq('Item 6')
      expect(json[:data][0][:attributes][:revenue]).to eq(250.0)
      expect(json[:data][4][:type]).to eq('item_revenue')
      expect(json[:data][4][:attributes][:name]).to eq('Item 1')
      expect(json[:data][4][:attributes][:revenue]).to eq(10.0)
    end

    it 'returns top one item if quantity is one' do
      get api_v1_revenue_items_path, params: { quantity: 1 }

      json = JSON.parse(response.body, symbolize_names: true)
      expect(response).to have_http_status(200)

      expect(json[:data].class).to eq(Array)
      expect(json[:data].size).to eq(1)
      expect(json[:data][0][:type]).to eq('item_revenue')
    end

    it 'returns all items if quantity is more than total merchants' do
      get api_v1_revenue_items_path, params: { quantity: 100 }

      json = JSON.parse(response.body, symbolize_names: true)
      expect(response).to have_http_status(200)

      expect(json[:data].class).to eq(Array)
      expect(json[:data].size).to eq(5)
    end

    it 'returns an error if the quantity param is not present' do
      get api_v1_revenue_items_path

      json = JSON.parse(response.body, symbolize_names: true)
      expect(response).to have_http_status(400)

      expect(json[:data]).to eq([])
    end

    it 'returns an error if quantity is left blank' do
      get api_v1_revenue_items_path, params: { quantity: '' }

      json = JSON.parse(response.body, symbolize_names: true)
      expect(response).to have_http_status(400)

      expect(json[:data]).to eq([])
    end

    it 'returns an error if quantity is a string' do
      get api_v1_revenue_items_path, params: { quantity: 'hello' }

      json = JSON.parse(response.body, symbolize_names: true)
      expect(response).to have_http_status(400)

      expect(json[:data]).to eq([])
    end

    it 'returns an error if quantity is less than 0' do
      get api_v1_revenue_items_path, params: { quantity: -5 }

      json = JSON.parse(response.body, symbolize_names: true)
      expect(response).to have_http_status(400)

      expect(json[:data]).to eq([])
    end
  end
end
