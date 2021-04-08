class Api::V1::Merchants::SearchController < ApplicationController
  def show
    if !params[:name] || params[:name].empty?
      render json: { data: {}, error: 'errors' }, status: 400
    else
      @merchant = Merchant.search_by_name(params[:name])
      merchant_search_serial

      render json: @serial
    end
  end
end
