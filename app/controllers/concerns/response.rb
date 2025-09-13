module Response
  extend ActiveSupport::Concern

  def json_success(data: {}, meta: {}, message: "Success", status: :ok)
    render json: {
      success: true,
      message: message,
      data: data,
      meta: meta
    }, status: status
  end

  def json_error(message: "Error", errors: {}, status: :unprocessable_entity)
    render json: {
      success: false,
      message: message,
      errors: errors
    }, status: status
  end
end
