require 'rails_helper'

RSpec.describe 'Api::V1::Items Show', type: :request do
  before :each do
    @merchant = create(:merchant)
    @item = create(:item, merchant_id: @merchant.id)
  end

  describe 'happy path' do
    it 'returns the item with the correct data' do
      get api_v1_item_path(@item)
      json = JSON.parse(response.body)
      expect(response).to have_http_status(200)

      expect(json['data'].class).to eq(Hash)
      expect(json['data']['id'].to_i).to eq(@item.id)
    end
  end

  describe 'sad path' do
    it 'bad id returns a 404' do
      expect { get '/api/v1/items/21' }.to raise_error(ActiveRecord::RecordNotFound)
    end
  end
end
