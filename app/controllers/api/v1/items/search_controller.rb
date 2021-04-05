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
end
