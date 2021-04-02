class Api::V1::Merchants::MerchantItemsController < ApplicationController
  def index
    @merchant_items = Merchant.find(params[:id]).items
    @serial = ItemSerializer.new(@merchant_items)
    render json: @serial
  end
end
