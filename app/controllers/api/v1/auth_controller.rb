class Api::V1::AuthController < ApplicationController
  skip_before_action :authorize_request, only: [:login, :register]

  rescue_from ActiveRecord::RecordNotUnique, with: :handle_duplicate

  def register
    user = User.new(user_params)

    if user.save
      token = jwt_encode(user_id: user.id, role: user.role)
      render json: { token: token, user: { id: user.id, fullname: user.fullname, role: user.role } }, status: :created
    else
      render json: { errors: user.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def login
    user = User.find_by(email: params[:email])

    if user && user.password_hash == params[:password] 
      token = jwt_encode(user_id: user.id, role: user.role)
      render json: { token: token, user: { id: user.id, fullname: user.fullname, role: user.role } }, status: :ok
    else
      render json: { error: "Password incorrect" }, status: :unauthorized
    end
  end

  private

  def user_params
    params.permit(:fullname, :email, :phone, :password_hash, :role)
  end

  def handle_duplicate(exception)
    render json: { error: "Email or phone number exist!." }, status: :unprocessable_entity
  end
end
