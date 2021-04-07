require 'rails_helper'

RSpec.describe "Api::V1::Revenue::Merchants Show", type: :request do
  before :each do
    setup_five_merchants_revenue
  end

  describe 'when i search for a single merchant' do
    it 'returns the merchant with its revenue when the id is valid' do
      get api_v1_merchant_revenue_show_path(@merchant_1)

      json = JSON.parse(response.body, symbolize_names: true)
      expect(response).to have_http_status(200)

      expect(json[:data].class).to eq(Hash)
      expect(json[:data][:type]).to eq('merchant_revenue')
      expect(json[:data][:attributes][:revenue]).to eq('10.0')
    end

    it 'returns an error if a bad id is given' do
      expect{ get api_v1_merchant_revenue_show_path(9999) }.to raise_error(ActiveRecord::RecordNotFound)
    end
  end
end
