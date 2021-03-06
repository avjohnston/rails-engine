require 'rails_helper'

RSpec.describe 'Api::V1::Items::Merchant', type: :request do
  before :each do
    @merchant = create(:merchant)
    @item = create(:item, merchant_id: @merchant.id)
  end

  describe 'happy path' do
    it 'gets the items merchant' do
      get api_v1_items_merchant_path(@item)

      json = JSON.parse(response.body)
      expect(response).to have_http_status(200)

      expect(json['data'].class).to eq(Hash)
      expect(json['data']['id'].to_i).to eq(@merchant.id)
      expect(json['data']['id'].to_i).to eq(@merchant.id)
    end
  end

  describe 'get /api/v1/items/:id/merchant sad path' do
    it 'bad id returns a 404' do
      expect { get '/api/v1/items/21/merchant' }.to raise_error(ActiveRecord::RecordNotFound)
    end
  end
end
