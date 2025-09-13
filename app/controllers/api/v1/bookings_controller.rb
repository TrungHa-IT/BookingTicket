class Api::V1::BookingsController < ApplicationController
  before_action :authorize_request , except: [:index, :show]
  before_action :set_booking, only: [:show, :update, :destroy]

  def index
    bookings = Booking.includes(:user, :show).all

    bookings = bookings.where(user_id: params[:user_id]) if params[:user_id].present?

    bookings = bookings.where(show_id: params[:show_id]) if params[:show_id].present?

    bookings = bookings.where(status: params[:status]) if params[:status].present?

    if params[:q].present?
      q = "%#{ActiveRecord::Base.sanitize_sql_like(params[:q])}%"
      bookings = bookings.joins(:user).where("users.fullname LIKE ?", q)
    end

    if params[:sort].present?
      if params[:sort].start_with?('-')
        bookings = bookings.order("#{params[:sort][1..]} DESC")
      else
        bookings = bookings.order("#{params[:sort]} ASC")
      end
    else
      bookings = bookings.order(created_at: :desc)
    end

    page = params.fetch(:page, 1).to_i
    per_page = params.fetch(:per_page, 10).to_i
    paged = bookings.page(page).per(per_page)

    render json: {
      data: paged.as_json(
        only: [:id, :booking_time, :total_amount, :status, :created_at],
        include: {
          user: { only: [:id, :fullname, :email] },
          show: { only: [:id, :show_day, :ticket_price] }
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
    }
  end

  def show
    render json: @booking.as_json(
      only: [:id, :booking_time, :total_amount, :status, :created_at],
      include: {
        user: { only: [:id, :fullname, :email] },
        show: { only: [:id, :show_day, :ticket_price] },
        booking_seats: { include: { seat: { only: [:id, :seat_row, :seat_number] } } },
        payment: { only: [:id, :payment_method, :amount, :status, :payment_date] }
      }
    )
  end

  def create
    booking = Booking.new(booking_params)
    booking.booking_time = Time.current

    if booking.save
      render json: booking, status: :created
    else
      render json: { errors: booking.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def update
    if @booking.update(booking_params)
      render json: @booking
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
    @booking = Booking.find_by(id: params[:id])
    render json: { error: "Booking not found" }, status: :not_found unless @booking
  end

  def booking_params
    params.permit(:user_id, :show_id, :total_amount, :status)
  end
end