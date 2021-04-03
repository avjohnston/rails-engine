require 'rails_helper'

RSpec.describe "Api::V1::Merchants Show", type: :request do
  let!(:merchant) {create(:merchant)}

  describe 'get /api/v1/merchant/:id' do
    before { get "/api/v1/merchants/#{merchant.id}" }

    it 'returns the merchant with the correct data' do
      json = JSON.parse(response.body)
      expect(response).to have_http_status(200)

      expect(json['data'].class).to eq(Hash)
      expect(json['data']['id'].to_i).to eq(merchant.id)
    end
  end

  describe 'get /api/v1/merchant/:id sad path' do
    it 'bad id returns a 404' do
      expect{ get '/api/v1/merchants/21' }.to raise_error(ActiveRecord::RecordNotFound)
    end
  end
end
