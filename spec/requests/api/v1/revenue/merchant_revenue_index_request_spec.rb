require 'rails_helper'

RSpec.describe "Api::V1::Revenue::Merchants Index", type: :request do
  before :each do
    setup_five_merchants_revenue
  end

  describe 'merchants revenue index' do
    describe 'when i search for merchants with the most revenue for a given quantity' do
      it 'returns the correct merchants with the correct format' do
        get api_v1_revenue_merchants_path, params: { quantity: 5 }

        json = JSON.parse(response.body, symbolize_names: true)
        expect(response).to have_http_status(200)

        expect(json[:data].class).to eq(Array)
        expect(json[:data].size).to eq(5)
        expect(json[:data][0][:type]).to eq('merchant_name_revenue')
        expect(json[:data][0][:attributes][:name]).to eq('Merchant 5 The Homie')
        expect(json[:data][0][:attributes][:revenue]).to eq('250.0')
        expect(json[:data][4][:type]).to eq('merchant_name_revenue')
        expect(json[:data][4][:attributes][:name]).to eq('Merchant 1')
        expect(json[:data][4][:attributes][:revenue]).to eq('10.0')
      end
    end

    it 'returns top one merchant if quantity is one' do
      get api_v1_revenue_merchants_path, params: { quantity: 1 }

      json = JSON.parse(response.body, symbolize_names: true)
      expect(response).to have_http_status(200)

      expect(json[:data].class).to eq(Array)
      expect(json[:data].size).to eq(1)
      expect(json[:data][0][:type]).to eq('merchant_name_revenue')
    end

    it 'returns all merchants if quantity is more than total merchants' do
      get api_v1_revenue_merchants_path, params: { quantity: 100 }

      json = JSON.parse(response.body, symbolize_names: true)
      expect(response).to have_http_status(200)

      expect(json[:data].class).to eq(Array)
      expect(json[:data].size).to eq(5)
    end

    it 'returns an error if the quantity param is not present' do
      get api_v1_revenue_merchants_path

      json = JSON.parse(response.body, symbolize_names: true)
      expect(response).to have_http_status(400)

      expect(json[:data]).to eq([])
    end

    it 'returns an error if quantity is left blank' do
      get api_v1_revenue_merchants_path, params: { quantity: '' }

      json = JSON.parse(response.body, symbolize_names: true)
      expect(response).to have_http_status(400)

      expect(json[:data]).to eq([])
    end

    it 'returns an error if quantity is a string' do
      get api_v1_revenue_merchants_path, params: { quantity: 'hello' }

      json = JSON.parse(response.body, symbolize_names: true)
      expect(response).to have_http_status(400)

      expect(json[:data]).to eq([])
    end

    it 'returns an error if quantity is less than 0' do
      get api_v1_revenue_merchants_path, params: { quantity: -5 }

      json = JSON.parse(response.body, symbolize_names: true)
      expect(response).to have_http_status(400)

      expect(json[:data]).to eq([])
    end
  end
end
