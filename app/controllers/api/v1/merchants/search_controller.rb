class Api::V1::Merchants::SearchController < ApplicationController
  def show
    @merchant = search_by_name(params[:name], Merchant)
    if @merchant.empty?
      render json: { data: {} }
    else
      @serial = MerchantSerializer.new(@merchant.first)

      render json: @serial
    end
  end
end
