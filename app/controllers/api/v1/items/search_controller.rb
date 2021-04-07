class Api::V1::Items::SearchController < ApplicationController
  def index
    @items = Item.search_by_name(params[:name])
    if @items.empty?
      render json: { data: [] }
    else
      @serial = ItemSerializer.new(@items)

      render json: @serial
    end
  end

  def show
    item_search_helper
    if @count
      item_define_helper
      serializer_edge_case

      render json: @serial
    else
      render json: { data: {}, error: 'errors' }, status: 400
    end
  end
end
