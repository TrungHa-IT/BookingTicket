class Api::V1::GenresController < ApplicationController
  before_action :authorize_request, except: [:index, :show]
  before_action :set_genre, only: [:show, :update, :destroy]
  
  def index
    genres = Genre.search(params[:q])
                  .sorted(params[:sort])

    page, per_page = set_pagination_params
    paged = genres.page(page).per(per_page)

    json_success(
      data: paged.as_json(only: [:id, :genre_name, :genre_description, :created_at]),
      meta: pagination_meta(paged)
    )
  end

  def show
    json_success(
      data: @genre.as_json(
        only: [:id, :genre_name, :genre_description, :created_at],
        include: { movies: { only: [:id, :title, :release_date] } }
      )
    )
  end

  def create
    genre = Genre.create!(genre_params)
    json_success(data: genre, message: "Genre created successfully", status: :created)
  end

  def update
    @genre.update!(genre_params)
    json_success(data: @genre, message: "Genre updated successfully")
  end

  def destroy
    @genre.destroy!
    head :no_content
  end

  private

  def set_genre
    @genre = Genre.find(params[:id])
  end

  def genre_params
    params.permit(:genre_name, :genre_description)
  end
end
