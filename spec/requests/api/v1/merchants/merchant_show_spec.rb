require 'rails_helper'

RSpec.describe "Api::V1::Merchants Show", type: :request do
  before :each do
    @merchant = create(:merchant)
  end

  describe 'happy path' do
    it 'returns the merchant with the correct data' do
      get api_v1_merchant_path(@merchant)

      json = JSON.parse(response.body, symbolize_names: true)
      expect(response).to have_http_status(200)

      expect(json[:data].class).to eq(Hash)
      expect(json[:data][:id].to_i).to eq(@merchant.id)
    end
  end

  describe 'sad path' do
    it 'bad id returns a 404' do
      expect{ get api_v1_merchant_path(55555) }.to raise_error(ActiveRecord::RecordNotFound)
    end
  end
end
