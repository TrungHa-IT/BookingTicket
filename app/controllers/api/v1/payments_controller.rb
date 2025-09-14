module Api
  module V1
    class PaymentsController < ApplicationController
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
            include: {
              booking: {
                only: [:id, :booking_time, :total_amount],
                include: { user: { only: [:id, :fullname, :email] } }
              }
            }
          ),
          meta: pagination_meta(paged)
        )
      end

      def show
        json_success(
          data: @payment.as_json(
            only: [:id, :payment_method, :amount, :status, :payment_date],
            include: {
              booking: {
                include: { user: { only: [:id, :fullname, :email] } }
              }
            }
          )
        )
      end

      def create
        ActiveRecord::Base.transaction do
          payment = Payment.create!(payment_params)

          case payment.status
          when "Pending"
            hold_seats(payment.booking)
          when "Failed"
            release_seats(payment.booking)
          when "Success"
            finalize_booking(payment.booking)
            send_success_email(payment)
          end

          json_success(data: payment, message: "Payment created successfully", status: :created)
        end
      end

      def update
        prev_status = @payment.status
        @payment.update!(payment_params)

        if prev_status != @payment.status
          case @payment.status
          when "Pending"
            hold_seats(@payment.booking)
          when "Failed"
            release_seats(@payment.booking)
          when "Success"
            finalize_booking(@payment.booking)
            send_success_email(@payment)
          end
        end

        json_success(data: @payment, message: "Payment updated successfully")
      end

      def destroy
        @payment.destroy!
        head :no_content
      end

      private

      def set_payment
        @payment = Payment.find(params[:id])
      end

      def payment_params
        params.permit(:booking_id, :payment_method, :amount, :payment_date, :status)
      end

      def hold_seats(booking)
        booking.booking_seats.each do |bs|
          seat_detail = SeatShowTimeDetail.find_by(
            seat_id: bs.seat_id,
            show_time_detail_id: bs.show_time_detail_id
          )
          seat_detail.update!(status: "Held") if seat_detail.present?
          bs.update!(hold_still: true)
        end
      end

      def release_seats(booking)
        booking.booking_seats.each do |bs|
          seat_detail = SeatShowTimeDetail.find_by(
            seat_id: bs.seat_id,
            show_time_detail_id: bs.show_time_detail_id
          )
          seat_detail.update!(status: "Available") if seat_detail.present?
          bs.update!(hold_still: false)
        end
      end

      def finalize_booking(booking)
        booking.booking_seats.each do |bs|
          seat_detail = SeatShowTimeDetail.find_by(
            seat_id: bs.seat_id,
            show_time_detail_id: bs.show_time_detail_id
          )
          seat_detail.update!(status: "Booked") if seat_detail.present?
          bs.update!(hold_still: false)
        end
      end

      def send_success_email(payment)
        PaymentMailer.success_email(payment).deliver_later
      end
    end
  end
end
