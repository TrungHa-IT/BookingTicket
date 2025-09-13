class Api::V1::SeatShowTimeDetailsController < ApplicationController
  before_action :authorize_request, except: [:index, :show]
  before_action :set_seat_show_time_detail, only: [:show, :update, :destroy]

  def index
    seats = SeatShowTimeDetail.includes(:show_time_detail, :seat)
                              .by_show_time_detail(params[:show_time_detail_id])
                              .by_seat(params[:seat_id])
                              .by_status(params[:status])
                              .sorted(params[:sort])

    page, per_page = set_pagination_params
    paged = seats.page(page).per(per_page)

    json_success(
      data: paged.as_json(
        only: [:id, :status, :created_at],
        include: {
          show_time_detail: { only: [:id, :start_time, :end_time] },
          seat: { only: [:id, :seat_row, :seat_number] }
        }
      ),
      meta: pagination_meta(paged)
    )
  end

  def show
    json_success(
      data: @seat_show_time_detail.as_json(
        only: [:id, :status, :created_at],
        include: {
          show_time_detail: { only: [:id, :start_time, :end_time] },
          seat: { only: [:id, :seat_row, :seat_number] }
        }
      )
    )
  end

  def create
    seat_detail = SeatShowTimeDetail.new(seat_show_time_detail_params)

    if seat_detail.save
      json_success(data: seat_detail, message: "SeatShowTimeDetail created successfully", status: :created)
    else
      json_error(errors: seat_detail.errors.full_messages)
    end
  end

  def update
    if @seat_show_time_detail.update(seat_show_time_detail_params)
      json_success(data: @seat_show_time_detail, message: "SeatShowTimeDetail updated successfully")
    else
      json_error(errors: @seat_show_time_detail.errors.full_messages)
    end
  end

  def destroy
    @seat_show_time_detail.destroy
    head :no_content
  end

  private

  def set_seat_show_time_detail
    @seat_show_time_detail = SeatShowTimeDetail.find(params[:id])
  end

  def seat_show_time_detail_params
    params.permit(:show_time_detail_id, :seat_id, :status)
  end
end
