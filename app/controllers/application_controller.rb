class ApplicationController < ActionController::API
  rescue_from ActiveRecord::RecordInvalid, with: :render_unprocessable_entity_response

  def render_unprocessable_entity_response(exception)
    render json: exception.record.errors, status: 404
  end

  def item_search_helper
    @item = Item.search_by_name(params[:name]) if only_name?
    @item = Item.price_range(params[:min_price], params[:max_price]) if min_and_max_price?
    @item = Item.min_price(params[:min_price]) if only_min_price?
    @item = Item.max_price(params[:max_price]) if only_max_price?
  end

  def only_name?
    params[:name] && !params[:min_price] && !params[:max_price]
  end

  def only_min_price?
    params[:min_price] && params[:min_price].to_i > 0 && !params[:name] && !params[:max_price]
  end

  def only_max_price?
    params[:max_price] && params[:max_price].to_i > 0 && !params[:name] && !params[:min_price]
  end

  def min_and_max_price?
    params[:min_price].to_i > 0 && params[:max_price].to_i > 0 && !params[:name] && params[:min_price].to_i < params[:max_price].to_i
  end

  def serializer_edge_case
    if @item.empty?
      @serial = { data: {} }
    else
      @serial = ItemSerializer.new(@item.first)
    end
  end

  def merchant_search_serial
    if @merchant.empty?
      @serial = { data: {} }
    else
      @serial = MerchantSerializer.new(@merchant.first)
    end
  end

  def item_search_serial
    if @items.empty?
      @serial = { data: [] }
    else
      @serial = ItemSerializer.new(@items)
    end
  end
end
