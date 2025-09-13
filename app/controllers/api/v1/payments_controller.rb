class Api::V1::PaymentsController < ApplicationController
  before_action :authorize_request
  before_action :set_payment, only: [:show, :update, :destroy]
  
  def index
    payments = Payment.includes(booking: :user)
                      .by_status(params[:status])
                      .by_payment_method(params[:payment_method])
                      .search(params[:q])
                      .sorted(params[:sort])

    page, per_page = set_pagination_params
    paged = payments.page(page).per(per_page)

    json_success(
      data: paged.as_json(
        only: [:id, :payment_method, :amount, :status, :payment_date],
        include: { booking: { only: [:id, :booking_time, :total_amount],
                              include: { user: { only: [:id, :fullname, :email] } } } }
      ),
      meta: pagination_meta(paged)
    )
  end

  def show
    json_success(
      data: @payment.as_json(
        only: [:id, :payment_method, :amount, :status, :payment_date],
        include: { booking: { include: { user: { only: [:id, :fullname, :email] } } } }
      )
    )
  end

  def create
    payment = Payment.new(payment_params)

    if payment.save
      # Send success email if payment is successful
      PaymentMailer.success_email(payment).deliver_later if payment.status == "Success"

      json_success(data: payment, message: "Payment created successfully", status: :created)
    else
      json_error(errors: payment.errors.full_messages)
    end
  end

  def update
    if @payment.update(payment_params)
      # Send success email if payment is successful
      send_success_email(@payment) if @payment.status == "Success"
      json_success(data: @payment, message: "Payment updated successfully")
    else
      json_error(errors: @payment.errors.full_messages)
    end
  end

  def destroy
    @payment.destroy
    head :no_content
  end

  private

  def set_payment
    @payment = Payment.find(params[:id])
  end

  def payment_params
    params.permit(:booking_id, :payment_method, :amount, :payment_date, :status)
  end

  def send_success_email(payment)
    user = payment.booking.user
    PaymentMailer.success_payment(user, payment).deliver_later
  end
end
