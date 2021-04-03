require 'rails_helper'

RSpec.describe "Api::V1::Items Show", type: :request do
  let!(:merchant) { create(:merchant) }
	let!(:item) {create(:item, merchant_id: merchant.id)}

  describe 'get /api/v1/items/:id' do
    before { get "/api/v1/items/#{item.id}" }

    it 'returns the item with the correct data' do
      json = JSON.parse(response.body)
      expect(response).to have_http_status(200)

      expect(json['data'].class).to eq(Hash)
      expect(json['data']['id'].to_i).to eq(item.id)
    end
  end

  describe 'get /api/v1/items/:id sad path' do
    it 'bad id returns a 404' do
      expect{ get '/api/v1/items/21' }.to raise_error(ActiveRecord::RecordNotFound)
    end
  end
end
