class Api::V1::Revenue::MerchantsController < ApplicationController
  def index
    if params[:quantity].present? && params[:quantity].to_i > 0
      @merchants = Merchant.top_merchants_by_revenue(params[:quantity])
      @serial = MerchantNameRevenueSerializer.new(@merchants)

      render json: @serial
    else
      render json: {data: [], error: 'error'}, status: 400
    end
  end

  def show
    @merchant = Merchant.find(params[:id])
    @serial = MerchantRevenueSerializer.new(@merchant)

    render json: @serial
  end
end
