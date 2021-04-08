require 'rails_helper'

RSpec.describe 'Api::V1::Merchants::Search', type: :request do
  before :each do
    @merchant_1 = create(:merchant, name: 'Andrew J')
    @merchant_2 = create(:merchant, name: 'Jandrew A')
  end

  describe 'when i search for an merchant by name' do
    it 'returns the first matching merchant alphabetically - case insensitive' do
      get api_v1_merchants_find_path, params: { name: 'An' }

      json = JSON.parse(response.body, symbolize_names: true)
      expect(response).to have_http_status(200)

      expect(json[:data].class).to eq(Hash)
      expect(json[:data][:id].to_i).to eq(@merchant_1.id)
      expect(json[:data][:attributes][:name]).to eq(@merchant_1.name)
    end

    it 'returns an empty hash if no results match' do
      get api_v1_merchants_find_path, params: { name: 'vwra' }

      json = JSON.parse(response.body, symbolize_names: true)
      expect(response).to have_http_status(200)

      expect(json[:data]).to eq({})
    end
  end

  describe 'sad path' do
    it 'returns status 400 when search param is not present' do
      get api_v1_merchants_find_path

      json = JSON.parse(response.body, symbolize_names: true)
      expect(response).to have_http_status(400)
    end

    it 'returns empty data when search param is present but empty' do
      get api_v1_merchants_find_path, params: { name: 'vwra' }

      json = JSON.parse(response.body, symbolize_names: true)
      expect(response).to have_http_status(200)

      expect(json[:data]).to eq({})
    end
  end
end
