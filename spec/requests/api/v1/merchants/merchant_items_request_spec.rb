require 'rails_helper'

RSpec.describe "Api::V1::Merchants::Items", type: :request do
  before :each do
    @merchant = create(:merchant)
  	@items = create_list(:item, 5, merchant_id: @merchant.id)
  end

  describe 'happy path' do
    it 'gets all the merchant items' do
      get api_v1_merchant_items_path(@merchant)

      json = JSON.parse(response.body, symbolize_names: true)
      expect(response).to have_http_status(200)

      expect(json[:data].class).to eq(Array)
      expect(json[:data].first[:id].to_i).to eq(@items.first.id)
      expect(json[:data].last[:id].to_i).to eq(@items.last.id)
    end
  end

  describe 'sad path' do
    it 'bad id returns a 404' do
      expect{ get api_v1_merchant_items_path(55555) }.to raise_error(ActiveRecord::RecordNotFound)
    end
  end
end
