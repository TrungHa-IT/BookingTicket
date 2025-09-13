class Api::V1::BookingsController < ApplicationController
  before_action :authorize_request, except: [:index, :show]
  before_action :set_booking, only: [:show, :update, :destroy]

  def index
    bookings = Booking.includes(:user, :show)
                      .by_user(params[:user_id])
                      .by_show(params[:show_id])
                      .search(params[:q])
                      .sorted(params[:sort])

    page, per_page = set_pagination_params
    paged = bookings.page(page).per(per_page)

    json_success(
      data: paged.as_json(
        only: [:id, :booking_time, :total_amount, :created_at],
        include: {
          user: { only: [:id, :fullname, :email] },
          show: { only: [:id, :show_day, :ticket_price] }
        }
      ),
      meta: pagination_meta(paged)
    )
  end

  def show
    json_success(
      data: @booking.as_json(
        only: [:id, :booking_time, :total_amount, :created_at],
        include: {
          user: { only: [:id, :fullname, :email] },
          show: { only: [:id, :show_day, :ticket_price] }
        }
      )
    )
  end

  def create
    booking = Booking.new(booking_params.merge(booking_time: Time.current))

    if booking.save
      json_success(data: booking, message: "Booking created successfully", status: :created)
    else
      render json: { errors: booking.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def update
    if @booking.update(booking_params)
      json_success(data: @booking, message: "Booking updated successfully")
    else
      render json: { errors: @booking.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy
    @booking.destroy
    head :no_content
  end

  private

  def set_booking
    @booking = Booking.find(params[:id])
  end

  def booking_params
    params.require(:booking).permit(:user_id, :show_id, :total_amount, :booking_time)
  end

end
