class Api::V1::ShowsController < ApplicationController
  before_action :authorize_request, except: [:index, :show]
  before_action :set_show, only: [:show, :update, :destroy]

  def index
    shows = Show.includes(:movie, :room, :cinema)
                .by_movie(params[:movie_id])
                .by_cinema(params[:cinema_id])
                .by_room(params[:room_id])
                .search(params[:q])
                .sorted(params[:sort])

    page, per_page = set_pagination_params
    paged = shows.page(page).per(per_page)

    json_success(
      data: paged.as_json(
        only: [:id, :show_day, :ticket_price, :created_at],
        include: {
          movie: { only: [:id, :title, :duration] },
          room: { only: [:id, :name] },
          cinema: { only: [:id, :name, :address] }
        }
      ),
      meta: pagination_meta(paged)
    )
  end

  def show
    json_success(
      data: @show.as_json(
        only: [:id, :show_day, :ticket_price, :created_at],
        include: {
          movie: { only: [:id, :title, :duration] },
          room: { only: [:id, :name] },
          cinema: { only: [:id, :name, :address] },
          show_time_details: { only: [:id, :start_time, :end_time] },
          bookings: { only: [:id, :booking_time, :total_amount, :status] }
        }
      )
    )
  end

  def create
    show = Show.new(show_params)

    if show.save
      json_success(data: show, message: "Show created successfully", status: :created)
    else
      json_error(errors: show.errors.full_messages)
    end
  end

  def update
    if @show.update(show_params)
      json_success(data: @show, message: "Show updated successfully")
    else
      json_error(errors: @show.errors.full_messages)
    end
  end

  def destroy
    @show.destroy
    head :no_content
  end

  private

  def set_show
    @show = Show.find(params[:id])
  end

  def show_params
    params.permit(:movie_id, :room_id, :cinema_id, :show_day, :ticket_price)
  end
end
