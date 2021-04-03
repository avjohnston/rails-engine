require 'rails_helper'

RSpec.describe "Api::V1::Items", type: :request do
  before :each do
    @merchant = create(:merchant)
    @item = create(:item, merchant_id: @merchant.id)
  end

  describe 'happy path' do
    it 'deletes a item given a valid id' do
      delete api_v1_item_path(@item)

      expect(response).to have_http_status(204)
    end
  end

  describe 'sad path' do
    it 'cant delete an item given an invalid id' do
      delete api_v1_item_path(99999999)

      expect(response).to have_http_status(404)
    end
  end
end
