require 'rails_helper'

RSpec.describe "Api::V1::Items", type: :request do
  let!(:merchant) { create(:merchant) }
	let!(:items) {create_list(:item, 50, merchant_id: merchant.id)}

  describe 'get api/v1/items' do
    before { get '/api/v1/items' }

    it 'returns first 20 items by default' do
      json = JSON.parse(response.body)
      expect(response).to have_http_status(200)

      expect(json['data']).to_not be_empty
      expect(json['data'].first['id'].to_i).to eq(items.first.id)
      expect(json['data'].last['id'].to_i).to_not eq(items.last.id)
      expect(json['data'].size).to eq(20)
    end
  end

  describe 'get /api/v1/items?page=2' do
    before { get '/api/v1/items?page=2' }

    it 'returns page 2 of our items' do
      json = JSON.parse(response.body)
      expect(response).to have_http_status(200)

      expect(json['data']).to_not be_empty
      expect(json['data'].first['id'].to_i).to_not eq(items.first.id)
      expect(json['data'].first['id'].to_i).to eq(items[20].id)
      expect(json['data'].last['id'].to_i).to eq(items[39].id)
      expect(json['data'].size).to eq(20)
    end
  end

  describe 'get /api/v1/items?per_page=50' do
    before { get '/api/v1/items?per_page=50' }

    it 'return 50 items per page' do
      json = JSON.parse(response.body)
      expect(response).to have_http_status(200)

      expect(json['data'].size).to eq(50)
      expect(json['data'].first['id'].to_i).to eq(items.first.id)
      expect(json['data'].last['id'].to_i).to eq(items[49].id)
    end
  end

  describe 'get /api/v1/items?per_page=150' do
    before { get '/api/v1/items?per_page=150' }

    it 'still returns all items if per_page is greater than all items' do
      json = JSON.parse(response.body)
      expect(response).to have_http_status(200)

      expect(json['data'].size).to eq(50)
      expect(json['data'].first['id'].to_i).to eq(items.first.id)
      expect(json['data'].last['id'].to_i).to eq(items.last.id)
    end
  end

  describe 'get /api/v1/items?page=2&per_page=15' do
    before { get '/api/v1/items?page=2&per_page=15' }

    it 'returns the correct amount per page with given param' do
      json = JSON.parse(response.body)
      expect(response).to have_http_status(200)

      expect(json['data'].size).to eq(15)
      expect(json['data'].first['id'].to_i).to eq(items[15].id)
      expect(json['data'].last['id'].to_i).to eq(items[29].id)
    end
  end

  describe 'get /api/v1/items?page=4&per_page=15' do
    before { get '/api/v1/items?page=4&per_page=15' }

    it 'last page doesnt break if there arent 15 items to display' do
      json = JSON.parse(response.body)
      expect(response).to have_http_status(200)

      expect(json['data'].size).to eq(5)
      expect(json['data'].first['id'].to_i).to eq(items[45].id)
      expect(json['data'].last['id'].to_i).to eq(items[49].id)
    end
  end

    describe 'get /api/v1/items?page=7' do
    before { get '/api/v1/items?page=7' }

    it 'calling a pge that doesnt have any items wont break it' do
      json = JSON.parse(response.body)
      expect(response).to have_http_status(200)

      expect(json['data'].size).to eq(0)
    end
  end
end
