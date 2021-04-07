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
    if item_search_helper
      item_object_search_helper
      @serial = ItemSerializer.new(@item)

      render json: @serial
    else
      render json: { data: {}, error: 'errors' }, status: 400
    end
  end
end
