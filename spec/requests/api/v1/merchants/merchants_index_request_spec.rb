require 'rails_helper'

RSpec.describe "Api::V1::Merchants", type: :request do
  let!(:merchants) {create_list(:merchant, 100)}

  describe 'get /api/v1/merchants' do
    before { get '/api/v1/merchants' }

    it 'returns first 20 merchants by default' do
      json = JSON.parse(response.body)
      expect(response).to have_http_status(200)

      expect(json['data']).to_not be_empty
      expect(json['data'].first['id'].to_i).to eq(merchants.first.id)
      expect(json['data'].last['id'].to_i).to_not eq(merchants.last.id)
      expect(json['data'].size).to eq(20)
    end
  end

  describe 'get /api/v1/merchants?page=2' do
    before { get '/api/v1/merchants?page=2' }

    it 'returns page 2 of our merchants' do
      json = JSON.parse(response.body)
      expect(response).to have_http_status(200)

      expect(json['data']).to_not be_empty
      expect(json['data'].first['id'].to_i).to_not eq(merchants.first.id)
      expect(json['data'].first['id'].to_i).to eq(merchants[20].id)
      expect(json['data'].last['id'].to_i).to eq(merchants[39].id)
      expect(json['data'].size).to eq(20)
    end
  end

  describe 'get /api/v1/merchants?per_page=50' do
    before { get '/api/v1/merchants?per_page=50' }

    it 'return 50 merchants per page' do
      json = JSON.parse(response.body)
      expect(response).to have_http_status(200)

      expect(json['data'].size).to eq(50)
      expect(json['data'].first['id'].to_i).to eq(merchants.first.id)
      expect(json['data'].last['id'].to_i).to eq(merchants[49].id)
    end
  end

  describe 'get /api/v1/merchants?per_page=150' do
    before { get '/api/v1/merchants?per_page=150' }

    it 'still returns all merchants if per_page is greater than all merchants' do
      json = JSON.parse(response.body)
      expect(response).to have_http_status(200)

      expect(json['data'].size).to eq(100)
      expect(json['data'].first['id'].to_i).to eq(merchants.first.id)
      expect(json['data'].last['id'].to_i).to eq(merchants.last.id)
    end
  end

  describe 'get /api/v1/merchants?page=2&per_page=15' do
    before { get '/api/v1/merchants?page=2&per_page=15' }

    it 'returns the correct amount per page with given param' do
      json = JSON.parse(response.body)
      expect(response).to have_http_status(200)

      expect(json['data'].size).to eq(15)
      expect(json['data'].first['id'].to_i).to eq(merchants[15].id)
      expect(json['data'].last['id'].to_i).to eq(merchants[29].id)
    end
  end

  describe 'get /api/v1/merchants?page=7&per_page=15' do
    before { get '/api/v1/merchants?page=7&per_page=15' }

    it 'last page doesnt break if there arent 15 merchants to display' do
      json = JSON.parse(response.body)
      expect(response).to have_http_status(200)

      expect(json['data'].size).to eq(10)
      expect(json['data'].first['id'].to_i).to eq(merchants[90].id)
      expect(json['data'].last['id'].to_i).to eq(merchants[99].id)
    end
  end

  describe 'get /api/v1/merchants?page=7' do
    before { get '/api/v1/merchants?page=7' }

    it 'calling a pge that doesnt have any merchants wont break it' do
      json = JSON.parse(response.body)
      expect(response).to have_http_status(200)

      expect(json['data'].size).to eq(0)
    end
  end
end
