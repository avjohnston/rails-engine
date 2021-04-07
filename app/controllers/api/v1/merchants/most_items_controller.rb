class Api::V1::Merchants::MostItemsController < ApplicationController
  def index
    if params[:quantity].present? && params[:quantity].to_i > 0
      @merchants = Merchant.most_items_sold(params[:quantity])
      @serial = ItemsSoldSerializer.new(@merchants)

      render json: @serial
    else
      render json: {data: [], error: 'error'}, status: 400
    end
  end
end
