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
    params[:max_price] && params[:max_price].to_i > 0 && !params[:name] ? true : false
    params[:name] && !params[:min_price] && !params[:max_price] ? true : false
    params[:min_price] && params[:max_price] && !params[:name] ? true : false
    params[:min_price] && params[:min_price].to_i > 0 && !params[:name] ? true : false
  end

  def item_object_search_helper
    if item_search_helper
      @item = Item.search_by_name(params[:name]).first
    elsif item_search_helper
      @item = Item.price_range(params[:min_price], params[:max_price]).first
    elsif item_search_helper
      @item = Item.min_price(params[:min_price]).first
    elsif item_search_helper
      @item = Item.max_price(params[:max_price]).first
    end
  end
end
