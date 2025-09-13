class Api::V1::MoviesController < ApplicationController
  before_action :authorize_request , except: [:index, :show]
  before_action :set_movie, only: [:show, :update, :destroy]

  def index
    movies = Movie.all

    movies = movies.where(status: params[:status]) if params[:status].present?

    if params[:genre_id].present?
      movies = movies.joins(:movie_types).where(movie_types: { genre_id: params[:genre_id] })
    end

    if params[:q].present?
      q = "%#{ActiveRecord::Base.sanitize_sql_like(params[:q])}%"
      movies = movies.where("title LIKE ?", q)
    end

    if params[:sort].present?
      if params[:sort].start_with?('-')
        movies = movies.order("#{params[:sort][1..]} DESC")
      else
        movies = movies.order("#{params[:sort]} ASC")
      end
    else
      movies = movies.order(created_at: :desc)
    end

    page = params.fetch(:page, 1).to_i
    per_page = params.fetch(:per_page, 10).to_i
    paged = movies.page(page).per(per_page)

    render json: {
      data: paged.as_json(
        only: [:id, :title, :duration_minutes, :status, :limit_age, :screening_day, :created_at],
        include: { genres: { only: [:id, :genre_name] } }
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
    render json: @movie.as_json(
      only: [:id, :title, :duration_minutes, :status, :limit_age, :screening_day, :created_at],
      include: { genres: { only: [:id, :genre_name] } }
    )
  end

  def create
    movie = Movie.new(movie_params)
    if movie.save
      render json: movie, status: :created
    else
      render json: { errors: movie.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def update
    if @movie.update(movie_params)
      render json: @movie
    else
      render json: { errors: @movie.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy
    @movie.destroy
    head :no_content
  end

  private

  def set_movie
    @movie = Movie.find_by(id: params[:id])
    render json: { error: "Movie not found" }, status: :not_found unless @movie
  end

  def movie_params
    params.permit(:title, :duration_minutes, :status, :limit_age, :screening_day, genre_ids: [])
  end
end
