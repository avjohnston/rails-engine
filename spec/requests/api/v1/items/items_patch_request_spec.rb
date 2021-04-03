require 'rails_helper'

RSpec.describe "Api::V1::Items::Merchant", type: :request do
  let!(:merchant) { create(:merchant) }
	let!(:item) {create(:item, merchant_id: merchant.id)}

  describe 'patch api/v1/items' do
    let(:valid_attributes) {
      {
        name: "new item",
        description: "new description",
        unit_price: 123.45,
        merchant_id: merchant.id
      }
    }
    before { patch "/api/v1/items/#{item.id}", params: valid_attributes }

    it 'updates an item given all new attributes' do
      json = JSON.parse(response.body)
      expect(response).to have_http_status(200)

      expect(json['data']['id'].to_i).to eq(item.id)
      expect(json['data']['attributes']['name']).to eq(valid_attributes[:name])
      expect(json['data']['attributes']['description']).to eq(valid_attributes[:description])
      expect(json['data']['attributes']['unit_price'].to_f).to eq(valid_attributes[:unit_price])
      expect(json['data']['attributes']['merchant_id']).to eq(valid_attributes[:merchant_id])
    end
  end

  describe 'patch api/v1/items' do
    let(:valid_attributes) {
      {
        name: "new item"
      }
    }
    before { patch "/api/v1/items/#{item.id}", params: valid_attributes }

    it 'updates an item given some new attributes' do
      json = JSON.parse(response.body)
      expect(response).to have_http_status(200)

      expect(json['data']['id'].to_i).to eq(item.id)
      expect(json['data']['attributes']['name']).to eq(valid_attributes[:name])
      expect(json['data']['attributes']['description']).to eq(item.description)
      expect(json['data']['attributes']['unit_price'].to_f).to eq(item.unit_price)
      expect(json['data']['attributes']['merchant_id']).to eq(item.merchant_id)
    end
  end

  describe 'patch api/v1/items sad path' do
    let(:invalid_attributes) {
      {
        name: "new item",
        description: "new description",
        unit_price: 123.45,
        merchant_id: merchant.id
      }
    }

    it 'updating item with invalid item id returns a 404' do
      expect{ patch "/api/v1/items/99999", params: invalid_attributes }.to raise_error(ActiveRecord::RecordNotFound)
    end
  end

  # describe 'patch api/v1/items sad path' do
  #   let(:invalid_attributes) {
  #     {
  #       name: "new item",
  #       description: "new description",
  #       unit_price: 123.45,
  #       merchant_id: 555555555555
  #     }
  #   }
  #
  #   it 'updating item with invalid merchant id returns a 404' do
  #     expect{ patch "/api/v1/items/#{item.id}", params: invalid_attributes }.to raise_error(ActiveRecord::RecordNotFound)
  #   end
  # end
end
