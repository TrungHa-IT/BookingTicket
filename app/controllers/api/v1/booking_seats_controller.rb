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
        ActiveRecord::Base.transaction do
          booking_seat = BookingSeat.create!(booking_seat_params)

          seat_detail = SeatShowTimeDetail.find_or_initialize_by(
            seat_id: booking_seat.seat_id,
            show_time_detail_id: booking_seat.show_time_detail_id
          )

          seat_detail.status = booking_seat.hold_still ? "Held" : "Booked"
          seat_detail.save!

          json_success(data: booking_seat, message: "BookingSeat created successfully", status: :created)
        end
      end

      def update
        ActiveRecord::Base.transaction do
          @booking_seat.update!(booking_seat_params)

          # Update trạng thái ghế
          seat_detail = SeatShowTimeDetail.find_by(
            seat_id: @booking_seat.seat_id,
            show_time_detail_id: @booking_seat.show_time_detail_id
          )

          if seat_detail.present?
            seat_detail.update!(status: @booking_seat.hold_still ? "Held" : "Booked")
          end

          json_success(data: @booking_seat, message: "BookingSeat updated successfully")
        end
      end

      def destroy
        ActiveRecord::Base.transaction do
          # Giải phóng ghế (trả về Available)
          seat_detail = SeatShowTimeDetail.find_by(
            seat_id: @booking_seat.seat_id,
            show_time_detail_id: @booking_seat.show_time_detail_id
          )

          seat_detail.update!(status: "Available") if seat_detail.present?

          @booking_seat.destroy!
        end

        head :no_content
      end

      private

      def set_booking_seat
        @booking_seat = BookingSeat.find(params[:id])
      end

      def booking_seat_params
        params.permit(:booking_id, :seat_id, :show_time_detail_id, :hold_still)
      end
    end
  end
end
