class Api::V1::UsersController < ApplicationController
  before_action :authorize_request, except: [:index, :show]
  before_action :set_user, only: [:show, :update, :destroy]

  def index
    users = User.by_role(params[:role])
                .search(params[:q])
                .sorted(params[:sort])

    page, per_page = set_pagination_params
    paged = users.page(page).per(per_page)

    json_success(
      data: paged.as_json(only: [:id, :fullname, :email, :phone, :role, :created_at]),
      meta: pagination_meta(paged)
    )
  end

  def show
    json_success(
      data: @user.as_json(only: [:id, :fullname, :email, :phone, :role, :created_at])
    )
  end

  def create
    user = User.new(user_params)

    if user.save
      json_success(
        data: user.as_json(only: [:id, :fullname, :email, :phone, :role, :created_at]),
        message: "User created successfully",
        status: :created
      )
    else
      json_error(errors: user.errors.full_messages)
    end
  end

  def update
    if @user.update(user_params)
      json_success(
        data: @user.as_json(only: [:id, :fullname, :email, :phone, :role, :updated_at]),
        message: "User updated successfully"
      )
    else
      json_error(errors: @user.errors.full_messages)
    end
  end

  def destroy
    @user.destroy
    head :no_content
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:fullname, :email, :phone, :password, :password_confirmation, :role)
  end
end
