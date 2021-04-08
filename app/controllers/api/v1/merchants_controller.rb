class Api::V1::MerchantsController < ApplicationController
  def index
    @objects = Merchant.page_helper(params[:page].to_i, params[:per_page].to_i)

    @serial = MerchantSerializer.new(@objects)
    render json: @serial
  end

  def show
    @merchant = Merchant.find(params[:id])
    @serial = MerchantSerializer.new(@merchant)

    render json: @serial
  end
end
