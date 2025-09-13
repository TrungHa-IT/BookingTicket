# app/lib/response.rb
module Response
  def json_success(data: nil, message: "Success", meta: nil, status: :ok)
    response = {
      success: true,
      message: message,
      data: data
    }
    response[:meta] = meta if meta.present?

    render json: response, status: status
  end

  def json_error(errors:, status: :unprocessable_entity)
    render json: {
      success: false,
      errors: Array(errors)
    }, status: status
  end
end
