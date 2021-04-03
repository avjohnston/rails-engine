class Api::V1::MerchantsController < ApplicationController
  def index
    page
    per_page
    page_helper(MerchantSerializer, Merchant)

    render json: @serial
  end

  def show
    @merchant = Merchant.find(params[:id])
    @serial = MerchantSerializer.new(@merchant)

    render json: @serial
  end
end
