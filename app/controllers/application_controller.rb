class ApplicationController < ActionController::API
  def page_helper(serializer, object)
    params[:page] = 1 if params[:page].to_i < 1 || !params[:page]
    params[:per_page] = 20 if params[:per_page].to_i < 1 || !params[:per_page]

    offset = ((params[:page].to_i - 1) * params[:per_page].to_i)
    objects = object.offset(offset).limit(params[:per_page])

    @serial = serializer.new(objects)
  end

  rescue_from ActiveRecord::RecordInvalid, with: :render_unprocessable_entity_response

  def render_unprocessable_entity_response(exception)
    render json: exception.record.errors, status: 404
  end

  def item_search_helper
    @count = 1 if params[:name] && !params[:min_price] && !params[:max_price]
    @count = 2 if params[:min_price].to_i > 0 && params[:max_price].to_i > 0 && !params[:name]
    @count = 3 if params[:min_price] && params[:min_price].to_i > 0 && !params[:name] && !params[:max_price]
    @count = 4 if params[:max_price] && params[:max_price].to_i > 0 && !params[:name] && !params[:min_price]
  end

  def item_define_helper
    if @count == 1
      @item = Item.search_by_name(params[:name]).first
    elsif @count == 2
      @item = Item.price_range(params[:min_price], params[:max_price]).first
    elsif @count == 3
      @item = Item.min_price(params[:min_price]).first
    elsif @count == 4
      @item = Item.max_price(params[:max_price]).first
    end
  end

  def serializer_edge_case
    if @item.nil?
      @serial = { data: {} }
    else
      @serial = ItemSerializer.new(@item)
    end
  end
end
