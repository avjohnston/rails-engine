class Api::V1::Merchants::SearchController < ApplicationController
  def show
    @merchant = Merchant.search_by_name(params[:name])
    if @merchant.empty?
      render json: { data: {} }
    else
      @serial = MerchantSerializer.new(@merchant.first)

      render json: @serial
    end
  end
end
