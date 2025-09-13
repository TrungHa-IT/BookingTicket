class ApplicationController < ActionController::API
  include Response

  before_action :authorize_request

  # Xử lý exception toàn cục
  rescue_from ActiveRecord::RecordNotFound,  with: :render_not_found
  rescue_from ActiveRecord::RecordInvalid,   with: :render_unprocessable_entity

  private

  # JWT encode/decode
  def jwt_encode(payload, exp = 24.hours.from_now)
    payload[:exp] = exp.to_i
    JWT.encode(payload, Rails.application.secret_key_base)
  end

  def jwt_decode(token)
    decoded = JWT.decode(token, Rails.application.secret_key_base)[0]
    HashWithIndifferentAccess.new(decoded)
  rescue JWT::DecodeError, JWT::ExpiredSignature
    nil
  end

  # Authorize user
  def authorize_request
    header = request.headers["Authorization"]&.split(" ")&.last
    decoded = jwt_decode(header)

    if decoded
      @current_user = User.find_by(id: decoded[:user_id])
    else
      json_error(message: "Unauthorized", status: :unauthorized)
    end
  end

  def current_user
    @current_user
  end

  def authorize_admin
    unless current_user&.role == 1
      json_error(message: "Chỉ admin mới được phép", status: :forbidden)
    end
  end

  # Exception handler
  def render_not_found(exception)
    json_error(message: exception.message, status: :not_found)
  end

  def render_unprocessable_entity(exception)
    json_error(
      message: "Validation failed",
      errors: exception.record.errors.full_messages,
      status: :unprocessable_entity
    )
  end

  # Pagination helpers
  def set_pagination_params
    page     = params.fetch(:page, 1).to_i
    per_page = params.fetch(:per_page, 10).to_i
    [page, per_page]
  end

  def pagination_meta(paged)
    {
      current_page: paged.current_page,
      next_page: paged.next_page,
      prev_page: paged.prev_page,
      total_pages: paged.total_pages,
      total_count: paged.total_count,
      per_page: paged.limit_value
    }
  end
end
