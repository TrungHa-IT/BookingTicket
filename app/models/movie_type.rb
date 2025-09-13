class MovieType < ApplicationRecord
  belongs_to :movie
  belongs_to :genre

  # Validations
  validates :movie_id, presence: true
  validates :genre_id, presence: true

  # Một cặp movie_id + genre_id chỉ được phép xuất hiện 1 lần
  validates :movie_id, uniqueness: { scope: :genre_id, message: "đã có genre này rồi" }
end