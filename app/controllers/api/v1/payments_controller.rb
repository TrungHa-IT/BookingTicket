class Api::V1::PaymentsController < ApplicationController
  before_action :authorize_request
  before_action :set_payment, only: [:show, :update, :destroy]

  def index
    payments = Payment.includes(:booking).all

    payments = payments.where(status: params[:status]) if params[:status].present?
    payments = payments.where(payment_method: params[:payment_method]) if params[:payment_method].present?

    if params[:q].present?
      q = "%#{ActiveRecord::Base.sanitize_sql_like(params[:q])}%"
      payments = payments.joins(booking: :user).where("users.fullname LIKE ?", q)
    end

    if params[:sort].present?
      if params[:sort].start_with?('-')
        payments = payments.order("#{params[:sort][1..]} DESC")
      else
        payments = payments.order("#{params[:sort]} ASC")
      end
    else
      payments = payments.order(created_at: :desc)
    end

    page = params.fetch(:page, 1).to_i
    per_page = params.fetch(:per_page, 10).to_i
    paged = payments.page(page).per(per_page)

    render json: {
      data: paged.as_json(
        only: [:id, :payment_method, :amount, :status, :payment_date],
        include: {
          booking: { only: [:id, :booking_time, :total_amount],
                     include: { user: { only: [:id, :fullname, :email] } } }
        }
      ),
      meta: {
        current_page: paged.current_page,
        next_page: paged.next_page,
        prev_page: paged.prev_page,
        total_pages: paged.total_pages,
        total_count: paged.total_count,
        per_page: paged.limit_value
      }
    }, status: :ok
  end

  def show
    render json: @payment.as_json(
      only: [:id, :payment_method, :amount, :status, :payment_date],
      include: { booking: { include: :user } }
    ), status: :ok
  end

  def create
  payment = Payment.new(payment_params)

  if payment.save
    if payment.status == "Success"
      PaymentMailer.success_payment(payment).deliver_later
    end

    render json: payment, status: :created
  else
    render json: { errors: payment.errors.full_messages }, status: :unprocessable_entity
  end
end


  def update
    if @payment.update(payment_params)
      send_success_email(@payment) if @payment.status == "Success"
      render json: @payment, status: :ok
    else
      render json: { errors: @payment.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy
    @payment.destroy
    head :no_content
  end

  private

  def set_payment
    @payment = Payment.find_by(id: params[:id])
    render json: { error: "Payment not found" }, status: :not_found unless @payment
  end

  def payment_params
    params.permit(:booking_id, :payment_method, :amount, :payment_date, :status)
  end

  def send_success_email(payment)
    user = payment.booking.user
    PaymentMailer.success_payment(user, payment).deliver_later
  end
end
