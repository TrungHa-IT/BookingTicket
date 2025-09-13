class ApplicationController < ActionController::API
  before_action :authorize_request

  private

  def jwt_encode(payload, exp = 24.hours.from_now)
    payload[:exp] = exp.to_i
    JWT.encode(payload, Rails.application.secret_key_base)
  end

  def jwt_decode(token)
    decoded = JWT.decode(token, Rails.application.secret_key_base)[0]
    HashWithIndifferentAccess.new decoded
  rescue JWT::DecodeError, JWT::ExpiredSignature
    nil
  end

  def authorize_request
    header = request.headers["Authorization"]
    header = header.split(" ").last if header

    decoded = jwt_decode(header)
    if decoded
      @current_user = User.find_by(id: decoded[:user_id])
    else
      render json: { error: "Unauthorized" }, status: :unauthorized
    end
  end

  def current_user
    @current_user
  end

  def authorize_admin
    unless current_user&.role == 1
      render json: { error: "Chỉ admin mới được phép" }, status: :forbidden
    end
  end
end
