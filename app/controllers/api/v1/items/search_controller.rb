class Api::V1::Items::SearchController < ApplicationController
  def index
    @items = search_by_name(params[:name], Item)
    if @items.empty?
      render json: { data: [] }
    else
      @serial = ItemSerializer.new(@items)

      render json: @serial
    end
  end
end
