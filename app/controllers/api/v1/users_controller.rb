class Api::V1::UsersController < ApplicationController
  before_action :authorize_request, except: [:index, :show]

  #before_action :set_user, only: [:show, :update, :destroy]

  # GET /api/v1/users
  def index
    users = User.all

    # filter
    users = users.where(role: params[:role]) if params[:role].present?

    # search
    if params[:q].present?
      q = "%#{ActiveRecord::Base.sanitize_sql_like(params[:q])}%"
      users = users.where("fullname LIKE ? OR email LIKE ? OR phone LIKE ?", q, q, q)
    end

    # sort
    if params[:sort].present?
      if params[:sort].start_with?('-')
        users = users.order("#{params[:sort][1..]} DESC")
      else
        users = users.order("#{params[:sort]} ASC")
      end
    else
      users = users.order(created_at: :desc)
    end

    # pagination
    page = params.fetch(:page, 1).to_i
    per_page = params.fetch(:per_page, 10).to_i
    paged = users.page(page).per(per_page)

    render json: {
      data: paged.as_json(only: [:id, :fullname, :email, :phone, :role, :created_at]),
      meta: {
        current_page: paged.current_page,
        next_page: paged.next_page,
        prev_page: paged.prev_page,
        total_pages: paged.total_pages,
        total_count: paged.total_count,
        per_page: paged.limit_value
      }
    }
  end

  # GET /api/v1/users/:id
  def show
    render json: @user.as_json(only: [:id, :fullname, :email, :phone, :role, :created_at])
  end

  # POST /api/v1/users
  def create
    user = User.new(user_params)
    if user.save
      render json: user.as_json(only: [:id, :fullname, :email, :phone, :role, :created_at]), status: :created
    else
      render json: { errors: user.errors.full_messages }, status: :unprocessable_entity
    end
  end

  # PUT/PATCH /api/v1/users/:id
  def update
    if @user.update(user_params)
      render json: @user.as_json(only: [:id, :fullname, :email, :phone, :role, :updated_at])
    else
      render json: { errors: @user.errors.full_messages }, status: :unprocessable_entity
    end
  end

  # DELETE /api/v1/users/:id
  def destroy
    @user.destroy
    head :no_content
  end

  private

  def set_user
    @user = User.find_by(id: params[:id])
    render json: { error: 'User not found' }, status: :not_found unless @user
  end

  def user_params
    params.require(:user).permit(:fullname, :email, :phone, :password, :password_confirmation, :role)
  end
end
