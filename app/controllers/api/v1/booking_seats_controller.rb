# app/controllers/api/v1/booking_seats_controller.rb
module Api
  module V1
    class BookingSeatsController < ApplicationController
      before_action :authorize_request, except: [:index, :show]
      before_action :set_booking_seat, only: [:show, :update, :destroy]

      def index
        booking_seats = BookingSeat.includes(:booking, :seat, :show_time_detail)
                                   .by_booking(params[:booking_id])
                                   .by_show_time_detail(params[:show_time_detail_id])
                                   .by_hold_still(params[:hold_still])
                                   .sorted(params[:sort])

        page, per_page = set_pagination_params
        paged = booking_seats.page(page).per(per_page)

        json_success(
          data: paged.as_json(
            only: [:id, :hold_still, :created_at],
            include: {
              booking: { only: [:id, :booking_time, :total_amount, :status] },
              seat: { only: [:id, :seat_row, :seat_number] },
              show_time_detail: { only: [:id, :start_time, :end_time] }
            }
          ),
          meta: pagination_meta(paged)
        )
      end

      def show
        json_success(
          data: @booking_seat.as_json(
            only: [:id, :hold_still, :created_at],
            include: {
              booking: { only: [:id, :booking_time, :total_amount, :status] },
              seat: { only: [:id, :seat_row, :seat_number] },
              show_time_detail: { only: [:id, :start_time, :end_time] }
            }
          )
        )
      end

      def create
        booking_seat = BookingSeat.new(booking_seat_params)

        if booking_seat.save
          json_success(data: booking_seat, message: "BookingSeat created successfully", status: :created)
        else
          json_error(errors: booking_seat.errors.full_messages)
        end
      end

      def update
        if @booking_seat.update(booking_seat_params)
          json_success(data: @booking_seat, message: "BookingSeat updated successfully")
        else
          json_error(errors: @booking_seat.errors.full_messages)
        end
      end

      def destroy
        @booking_seat.destroy
        head :no_content
      end

      private

      def set_booking_seat
        @booking_seat = BookingSeat.find(params[:id])
      rescue ActiveRecord::RecordNotFound
        render json: { error: "BookingSeat not found" }, status: :not_found
      end

      def booking_seat_params
        params.permit(:booking_id, :seat_id, :show_time_detail_id, :hold_still)
      end
    end
  end
end
