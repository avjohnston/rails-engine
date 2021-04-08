require 'rails_helper'

RSpec.describe 'Api::V1::Merchants', type: :request do
  before :each do
    one_hundred_merchants
  end
  describe 'happy path' do
    it 'returns first 20 merchants by default' do
      get api_v1_merchants_path

      @merchants = Merchant.order(:id).limit(20).offset(0)

      json = JSON.parse(response.body, symbolize_names: true)
      expect(response).to have_http_status(200)

      expect(json[:data].size).to eq(20)
      expect(json[:data].first[:id].to_i).to eq(@merchants.first.id)
      expect(json[:data].last[:id].to_i).to eq(@merchants[19].id)
    end

    it 'returns page 2 of our merchants' do
      get api_v1_merchants_path, params: { page: 2 }

      @merchants = Merchant.order(:id).limit(20).offset(20)

      json = JSON.parse(response.body, symbolize_names: true)
      expect(response).to have_http_status(200)

      expect(json[:data].size).to eq(20)
      expect(json[:data].first[:id].to_i).to eq(@merchants[0].id)
      expect(json[:data].last[:id].to_i).to eq(@merchants[19].id)
    end

    it 'return 50 merchants per page' do
      get api_v1_merchants_path, params: { per_page: 50 }

      @merchants = Merchant.order(:id).limit(50).offset(0)

      json = JSON.parse(response.body, symbolize_names: true)
      expect(response).to have_http_status(200)

      expect(json[:data].size).to eq(50)
      expect(json[:data].first[:id].to_i).to eq(@merchants.first.id)
      expect(json[:data].last[:id].to_i).to eq(@merchants[49].id)
    end

    it 'returns the correct amount per page with given param' do
      get api_v1_merchants_path, params: { page: 2, per_page: 15 }

      @merchants = Merchant.order(:id).limit(15).offset(15)

      json = JSON.parse(response.body, symbolize_names: true)
      expect(response).to have_http_status(200)

      expect(json[:data].size).to eq(15)
      expect(json[:data].first[:id].to_i).to eq(@merchants[0].id)
      expect(json[:data].last[:id].to_i).to eq(@merchants[14].id)
    end
  end

  describe 'sad path' do
    it 'still returns all merchants if per_page is greater than all merchants' do
      get api_v1_merchants_path, params: { per_page: 150 }

      @merchants = Merchant.order(:id).limit(150).offset(0)

      json = JSON.parse(response.body, symbolize_names: true)
      expect(response).to have_http_status(200)

      expect(json[:data].size).to eq(100)
      expect(json[:data].first[:id].to_i).to eq(@merchants.first.id)
      expect(json[:data].last[:id].to_i).to eq(@merchants.last.id)
    end

    it 'last page doesnt break if there arent 15 merchants to display' do
      get api_v1_merchants_path, params: { page: 7, per_page: 15 }

      @merchants = Merchant.order(:id).limit(15).offset(90)


      json = JSON.parse(response.body, symbolize_names: true)
      expect(response).to have_http_status(200)

      expect(json[:data].size).to eq(10)
      expect(json[:data].first[:id].to_i).to eq(@merchants[0].id)
      expect(json[:data].last[:id].to_i).to eq(@merchants[9].id)
    end

    it 'calling a page that doesnt have any merchants wont break it' do
      get api_v1_merchants_path, params: { page: 7 }

      @merchants = Merchant.order(:id).limit(20).offset(120)

      json = JSON.parse(response.body, symbolize_names: true)
      expect(response).to have_http_status(200)

      expect(json[:data].size).to eq(0)
    end

    it 'defaults to page 1 and 20 per page if either is less than 0' do
      get api_v1_merchants_path, params: { page: -4, per_page: -15 }

      @merchants = Merchant.order(:id).limit(20).offset(0)

      json = JSON.parse(response.body, symbolize_names: true)
      expect(response).to have_http_status(200)

      expect(json[:data].size).to eq(20)
      expect(json[:data].first[:id].to_i).to eq(@merchants.first.id)
      expect(json[:data].last[:id].to_i).to eq(@merchants[19].id)
    end

    it 'defaults to page 1 and 20 per page if either is less than 0' do
      get api_v1_merchants_path, params: { page: 1, per_page: -15 }

      @merchants = Merchant.order(:id).limit(20).offset(0)

      json = JSON.parse(response.body, symbolize_names: true)
      expect(response).to have_http_status(200)

      expect(json[:data].size).to eq(20)
      expect(json[:data].first[:id].to_i).to eq(@merchants.first.id)
      expect(json[:data].last[:id].to_i).to eq(@merchants[19].id)
    end

    it 'defaults to page 1 and 20 per page if either is less than 0' do
      get api_v1_merchants_path, params: { page: -4, per_page: 15 }

      @merchants = Merchant.order(:id).limit(15).offset(0)

      json = JSON.parse(response.body, symbolize_names: true)
      expect(response).to have_http_status(200)

      expect(json[:data].size).to eq(15)
      expect(json[:data].first[:id].to_i).to eq(@merchants.first.id)
      expect(json[:data].last[:id].to_i).to eq(@merchants[14].id)
    end
  end
end
