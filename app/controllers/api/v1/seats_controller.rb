# app/controllers/api/v1/seats_controller.rb
class Api::V1::SeatsController < ApplicationController
  before_action :authorize_request, except: [:index, :show]
  before_action :set_seat, only: [:show, :update, :destroy]

  def index
    seats = Seat.all
    seats = seats.where(room_id: params[:room_id]) if params[:room_id].present?

    page = params.fetch(:page, 1).to_i
    per_page = params.fetch(:per_page, 10).to_i
    paged = seats.page(page).per(per_page)

    render json: {
      data: paged.as_json(
        only: [:id, :seat_number, :seat_row, :room_id, :created_at],
        include: { room: { only: [:id, :room_name] } }
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
    render json: @seat.as_json(
      only: [:id, :seat_number, :seat_row, :room_id, :created_at],
      include: { room: { only: [:id, :room_name] } }
    )
  end

  def create
    seat = Seat.new(seat_params)
    if seat.save
      render json: seat, status: :created
    else
      render json: { errors: seat.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def update
    if @seat.update(seat_params)
      render json: @seat
    else
      render json: { errors: @seat.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy
    @seat.destroy
    head :no_content
  end

  private

  def set_seat
    @seat = Seat.find_by(id: params[:id])
    render json: { error: "Seat not found" }, status: :not_found unless @seat
  end

  def seat_params
    params.permit(:seat_number, :seat_row, :room_id)
  end
end
