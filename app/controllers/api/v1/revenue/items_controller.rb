class Api::V1::Revenue::ItemsController < ApplicationController
  def index
    if params[:quantity] && params[:quantity].to_i > 0
      @items = Item.most_revenue(params[:quantity].to_i)
      @serial = ItemRevenueSerializer.new(@items)

      render json: @serial, status: 200
    else
      render json: { data: [], error: 'error' }, status: 400
    end
  end
end
