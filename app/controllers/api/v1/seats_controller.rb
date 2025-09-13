# app/controllers/api/v1/seats_controller.rb
class Api::V1::SeatsController < ApplicationController
  before_action :authorize_request, except: [:index, :show]
  before_action :set_seat, only: [:show, :update, :destroy]

  def index
    seats = Seat.includes(:room)
                .by_room(params[:room_id])
                .search(params[:q])
                .sorted(params[:sort])

    page, per_page = set_pagination_params
    paged = seats.page(page).per(per_page)

    json_success(
      data: paged.as_json(
        only: [:id, :seat_number, :seat_row, :room_id, :created_at],
        include: { room: { only: [:id, :room_name] } }
      ),
      meta: pagination_meta(paged)
    )
  end

  def show
    json_success(
      data: @seat.as_json(
        only: [:id, :seat_number, :seat_row, :room_id, :created_at],
        include: { room: { only: [:id, :room_name] } }
      )
    )
  end

  def create
    seat = Seat.new(seat_params)
    if seat.save
      json_success(data: seat, message: "Seat created successfully", status: :created)
    else
      json_error(message: "Validation failed", errors: seat.errors.full_messages)
    end
  end

  def update
    if @seat.update(seat_params)
      json_success(data: @seat, message: "Seat updated successfully")
    else
      json_error(message: "Validation failed", errors: @seat.errors.full_messages)
    end
  end

  def destroy
    @seat.destroy
    json_success(message: "Seat deleted successfully")
  end

  private

  def set_seat
    @seat = Seat.find(params[:id]) 
  end

  def seat_params
    params.permit(:seat_number, :seat_row, :room_id)
  end
end
