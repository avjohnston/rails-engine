require 'rails_helper'

RSpec.describe "Api::V1::Merchants::Items", type: :request do
  let!(:merchant) { create(:merchant) }
	let!(:items) {create_list(:item, 5, merchant_id: merchant.id)}

  describe 'get api/v1/merchants/:id/items' do
    before { get "/api/v1/merchants/#{merchant.id}/items" }

    it 'gets all the merchant items' do
      json = JSON.parse(response.body)
      expect(response).to have_http_status(200)

      expect(json['data'].class).to eq(Array)
      expect(json['data'].first['id'].to_i).to eq(items.first.id)
      expect(json['data'].last['id'].to_i).to eq(items.last.id)
    end
  end

  describe 'get /api/v1/merchant/:id/items sad path' do
    it 'bad id returns a 404' do
      expect{ get "/api/v1/merchants/21/items" }.to raise_error(ActiveRecord::RecordNotFound)
    end
  end
end
