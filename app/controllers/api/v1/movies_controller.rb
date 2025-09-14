class Api::V1::MoviesController < ApplicationController
  before_action :authorize_request, except: [:index, :show]
  before_action :set_movie, only: [:show, :update, :destroy]

  def index
    movies = Movie.all
                  .by_status(params[:status])
                  .by_genre(params[:genre_id])
                  .search(params[:q])
                  .order_by_sort(params[:sort])

    page, per_page = set_pagination_params
    paged = movies.page(page).per(per_page)

    json_success(
      data: paged.as_json(
        only: [:id, :title, :duration_minutes, :status, :limit_age, :screening_day, :created_at],
        include: { genres: { only: [:id, :genre_name] } }
      ),
      meta: pagination_meta(paged)
    )
  end

  def show
    json_success(
      data: @movie.as_json(
        only: [:id, :title, :duration_minutes, :status, :limit_age, :screening_day, :created_at],
        include: { genres: { only: [:id, :genre_name] } }
      )
    )
  end

  def create
    movie = Movie.create!(movie_params)
    json_success(data: movie, message: "Movie created successfully", status: :created)
  end

  def update
    @movie.update!(movie_params)
    json_success(data: @movie, message: "Movie updated successfully")
  end

  def destroy
    @movie.destroy!
    json_success(message: "Movie deleted successfully")
  end

  private

  def set_movie
    @movie = Movie.find(params[:id])
  end

  def movie_params
    params.permit(:title, :duration_minutes, :status, :limit_age, :screening_day, genre_ids: [])
  end
end
