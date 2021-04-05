class ApplicationController < ActionController::API
  include ActionController::Helpers

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

  # rescue_from ActiveRecord::RecordNotFound, with: :record_not_found

  # def record_not_found(exception)
  #   render json: { error: exception.message }, status: :not_found
  # end

  helper_method :page_helper, :search_by_name
end
