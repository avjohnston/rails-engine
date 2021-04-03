require 'rails_helper'

RSpec.describe "Api::V1::Items", type: :request do
  before :each do
    @merchant = create(:merchant)
  	@items =  create_list(:item, 50, merchant_id: @merchant.id)
  end

  describe 'happy path' do
    it 'returns first 20 items by default' do
      get api_v1_items_path

      json = JSON.parse(response.body, symbolize_names: true)
      expect(response).to have_http_status(200)

      expect(json[:data].size).to eq(20)
      expect(json[:data].first[:id].to_i).to eq(@items.first.id)
      expect(json[:data].last[:id].to_i).to_not eq(@items.last.id)
      expect(json[:data].last[:id].to_i).to eq(@items[19].id)
    end

    it 'returns page 2 of our items' do
      get api_v1_items_path, params: { page: 2 }

      json = JSON.parse(response.body, symbolize_names: true)
      expect(response).to have_http_status(200)

      expect(json[:data].size).to eq(20)
      expect(json[:data].first[:id].to_i).to_not eq(@items.first.id)
      expect(json[:data].first[:id].to_i).to eq(@items[20].id)
      expect(json[:data].last[:id].to_i).to eq(@items[39].id)
    end

    it 'return 50 items per page' do
      get api_v1_items_path, params: { per_page: 50 }

      json = JSON.parse(response.body, symbolize_names: true)
      expect(response).to have_http_status(200)

      expect(json[:data].size).to eq(50)
      expect(json[:data].first[:id].to_i).to eq(@items.first.id)
      expect(json[:data].last[:id].to_i).to eq(@items[49].id)
    end

    it 'returns the correct amount per page with given param' do
      get api_v1_items_path, params: { page: 2, per_page: 15 }

      json = JSON.parse(response.body, symbolize_names: true)
      expect(response).to have_http_status(200)

      expect(json[:data].size).to eq(15)
      expect(json[:data].first[:id].to_i).to eq(@items[15].id)
      expect(json[:data].last[:id].to_i).to eq(@items[29].id)
    end

    describe 'sad path' do
      it 'calling a page that doesnt have any items wont break it' do
        get api_v1_items_path, params: { page: 7 }

        json = JSON.parse(response.body, symbolize_names: true)
        expect(response).to have_http_status(200)

        expect(json[:data].size).to eq(0)
      end

      it 'last page doesnt break if there arent 15 items to display' do
        get api_v1_items_path, params: { page: 4, per_page: 15 }

        json = JSON.parse(response.body, symbolize_names: true)
        expect(response).to have_http_status(200)

        expect(json[:data].size).to eq(5)
        expect(json[:data].first[:id].to_i).to eq(@items[45].id)
        expect(json[:data].last[:id].to_i).to eq(@items[49].id)
      end

      it 'still returns all items if per_page is greater than all items' do
        get api_v1_items_path, params: { per_page: 150 }

        json = JSON.parse(response.body, symbolize_names: true)
        expect(response).to have_http_status(200)

        expect(json[:data].size).to eq(50)
        expect(json[:data].first[:id].to_i).to eq(@items.first.id)
        expect(json[:data].last[:id].to_i).to eq(@items.last.id)
      end

      it 'defaults to page 1 and 20 per page if either is less than 0' do
        get api_v1_items_path, params: { page: -4, per_page: -15 }

        json = JSON.parse(response.body, symbolize_names: true)
        expect(response).to have_http_status(200)

        expect(json[:data].size).to eq(20)
        expect(json[:data].first[:id].to_i).to eq(@items.first.id)
        expect(json[:data].last[:id].to_i).to_not eq(@items.last.id)
        expect(json[:data].last[:id].to_i).to eq(@items[19].id)
      end
    end
  end
end
