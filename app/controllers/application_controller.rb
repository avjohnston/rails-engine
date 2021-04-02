class ApplicationController < ActionController::API
  include ActionController::Helpers

  def page
    params[:page].to_i < 1 ? @page = 1 : @page = params[:page].to_i
  end

  def per_page
    params[:per_page].to_i < 1 ? @per_page = 20 : @per_page = params[:per_page].to_i
  end

  def page_helper(serializer, object)
    if params[:page] && !params[:per_page]
      @serial = serializer.new(object.limit(20).offset(20 * (@page - 1)))
    elsif !params[:page] && params[:per_page]
      @serial = serializer.new(object.limit(@per_page))
    elsif params[:page] && params[:per_page]
      @serial = serializer.new(object.limit(@per_page).offset(@per_page * (@page - 1)))
    else
      @serial = serializer.new(object.limit(20))
    end
  end

  helper_method :page, :per_page, :page_helper
end
