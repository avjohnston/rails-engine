require 'rails_helper'

RSpec.describe "Api::V1::Items::Search Index", type: :request do
  before :each do
    @merchant_1 = create(:merchant, name: 'Andrew J')
    @merchant_2 = create(:merchant, name: 'Jandrew A')
    @item_1 = create(:item, name: 'Item Bulo', description: 'Item')
    @item_2 = create(:item, name: 'Item Should', description: 'Item')
    @item_3 = create(:item, name: 'Item Hello', description: 'Item')
  end

  describe 'when i search for items by name' do
    it 'returns all items that match name ordered alphabetically - case insensitive' do
      get api_v1_items_find_all_path, params: {name: 'ul'}

      json = JSON.parse(response.body, symbolize_names: true)
      expect(response).to have_http_status(200)

      expect(json[:data].size).to eq(2)
      expect(json[:data][0][:id].to_i).to eq(@item_1.id)
      expect(json[:data][0][:attributes][:name]).to eq(@item_1.name)
      expect(json[:data][1][:id].to_i).to eq(@item_2.id)
      expect(json[:data][1][:attributes][:name]).to eq(@item_2.name)
    end

    it 'returns empty array if no item names match search' do
      get api_v1_items_find_all_path, params: {name: 'vavzxz'}

      json = JSON.parse(response.body, symbolize_names: true)
      expect(response).to have_http_status(200)

      expect(json[:data].size).to eq(0)
      expect(json[:data]).to eq([])
    end
  end

  describe 'sad path' do
    it 'returns status 400 when search param is not present' do
      get api_v1_items_find_all_path

      json = JSON.parse(response.body, symbolize_names: true)
      expect(response).to have_http_status(400)
    end

    it 'returns empty data when search param is present but empty' do
      get api_v1_items_find_all_path, params: {name: 'vwra'}

      json = JSON.parse(response.body, symbolize_names: true)
      expect(response).to have_http_status(200)

      expect(json[:data]).to eq([])
    end
  end
end
