require 'rails_helper'

RSpec.describe 'Api::V1::Items Create', type: :request do
  before :each do
    @merchant = create(:merchant)
    @valid_merchant = @merchant.id
    @valid_attributes = {
      name: 'new item',
      description: 'new description',
      unit_price: 123.45,
      merchant_id: @valid_merchant
    }
  end

  describe 'happy path' do
    it 'creates a new item' do
      post api_v1_items_path, params: @valid_attributes

      json = JSON.parse(response.body)
      expect(response).to have_http_status(201)

      expect(json['data'].class).to eq(Hash)
      expect(json['data']['attributes']['name']).to eq(@valid_attributes[:name])
      expect(json['data']['attributes']['description']).to eq(@valid_attributes[:description])
      expect(json['data']['attributes']['unit_price'].to_f).to eq(@valid_attributes[:unit_price])
      expect(json['data']['attributes']['merchant_id']).to eq(@valid_attributes[:merchant_id])
    end
  end
end
