class Genre < ApplicationRecord
  has_many :movie_types, dependent: :destroy
  has_many :movies, through: :movie_types

  # Validations
  validates :genre_name, presence: true,
                         uniqueness: { case_sensitive: false },
                         length: { maximum: 100 }

  validates :genre_description, presence: true,
                                length: { maximum: 255 }
end