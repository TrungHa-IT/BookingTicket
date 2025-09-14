class Api::V1::RoomsController < ApplicationController
  before_action :authorize_request, except: [:index, :show]
  before_action :set_room, only: [:show, :update, :destroy]

  def index
    rooms = Room.includes(:cinema)
                .by_cinema(params[:cinema_id])
                .search(params[:q])
                .sorted(params[:sort])

    page, per_page = set_pagination_params
    paged = rooms.page(page).per(per_page)

    json_success(
      data: paged.as_json(
        only: [:id, :name, :seat_capacity, :created_at],
        include: { cinema: { only: [:id, :name, :address] } }
      ),
      meta: pagination_meta(paged)
    )
  end

  def show
    json_success(
      data: @room.as_json(
        only: [:id, :name, :seat_capacity, :created_at],
        include: {
          cinema: { only: [:id, :name, :address] },
          seats: { only: [:id, :seat_row, :seat_number] },
          shows: { only: [:id, :show_day, :ticket_price] }
        }
      )
    )
  end

  def create
    room = Room.create!(room_params)
    json_success(data: room, message: "Room created successfully", status: :created)
  end

  def update
    @room.update!(room_params)
    json_success(data: @room, message: "Room updated successfully")
  end

  def destroy
    @room.destroy!
    head :no_content
  end

  private

  def set_room
    @room = Room.find(params[:id])
  end

  def room_params
    params.permit(:cinema_id, :name, :seat_capacity)
  end
end
