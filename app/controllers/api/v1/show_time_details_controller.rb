class Api::V1::ShowTimeDetailsController < ApplicationController
  before_action :authorize_request, except: [:index, :show]
  before_action :set_show_time_detail, only: [:show, :update, :destroy]

  def index
    show_times = ShowTimeDetail.includes(:show)
                               .by_show(params[:show_id])
                               .sorted(params[:sort])

    page, per_page = set_pagination_params
    paged = show_times.page(page).per(per_page)

    json_success(
      data: paged.as_json(
        only: [:id, :start_time, :end_time, :created_at],
        include: {
          show: { only: [:id, :show_day, :ticket_price] },
          booking_seats: { include: { seat: { only: [:id, :seat_row, :seat_number] } } }
        }
      ),
      meta: pagination_meta(paged)
    )
  end

  def show
    json_success(
      data: @show_time_detail.as_json(
        only: [:id, :start_time, :end_time, :created_at],
        include: {
          show: { only: [:id, :show_day, :ticket_price] },
          booking_seats: { include: { seat: { only: [:id, :seat_row, :seat_number] } } },
          seat_show_time_details: { only: [:id, :status],
                                    include: { seat: { only: [:id, :seat_row, :seat_number] } } }
        }
      )
    )
  end

  def create
    show_time_detail = ShowTimeDetail.create!(show_time_detail_params)
    json_success(data: show_time_detail, message: "ShowTimeDetail created successfully", status: :created)
  end

  def update
    @show_time_detail.update!(show_time_detail_params)
    json_success(data: @show_time_detail, message: "ShowTimeDetail updated successfully")
  end

  def destroy
    @show_time_detail.destroy!
    head :no_content
  end

  private

  def set_show_time_detail
    @show_time_detail = ShowTimeDetail.find(params[:id])
  end

  def show_time_detail_params
    params.permit(:show_id, :start_time, :end_time)
  end
end
