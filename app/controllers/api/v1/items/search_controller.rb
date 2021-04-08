class Api::V1::Items::SearchController < ApplicationController
  def index
    if !params[:name] || params[:name].empty?
      render json: { data: [], error: 'errors' }, status: 400
    else
      @items = Item.search_by_name(params[:name])
      item_search_serial

      render json: @serial
    end
  end

  def show
    item_search_helper
    if @item
      serializer_edge_case

      render json: @serial
    else
      render json: { data: {}, error: 'errors' }, status: 400
    end
  end
end
