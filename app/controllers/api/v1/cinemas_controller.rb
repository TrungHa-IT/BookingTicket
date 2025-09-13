class Api::V1::CinemasController < ApplicationController
  before_action :authorize_request, except: [:index, :show]
  before_action :set_cinema, only: [:show, :update, :destroy]

  def index
    cinemas = Cinema.search(params[:q]).sorted(params[:sort])

    page, per_page = set_pagination_params
    paged = cinemas.page(page).per(per_page)

    json_success(
      data: paged.as_json(
        only: [:id, :name, :address, :created_at],
        include: { rooms: { only: [:id, :name, :seat_capacity] } }
      ),
      meta: pagination_meta(paged)
    )
  end

  def show
    json_success(
      data: @cinema.as_json(
        only: [:id, :name, :address, :created_at],
        include: { rooms: { only: [:id, :name, :seat_capacity] } }
      )
    )
  end

  def create
    cinema = Cinema.new(cinema_params)

    if cinema.save
      json_success(data: cinema, message: "Cinema created successfully", status: :created)
    else
      json_error(errors: cinema.errors.full_messages)
    end
  end

  def update
    if @cinema.update(cinema_params)
      json_success(data: @cinema, message: "Cinema updated successfully")
    else
      json_error(errors: @cinema.errors.full_messages)
    end
  end

  def destroy
    @cinema.destroy
    head :no_content
  end

  private

  def set_cinema
    @cinema = Cinema.find(params[:id])
  end

  def cinema_params
    params.permit(:name, :address)
  end
end
