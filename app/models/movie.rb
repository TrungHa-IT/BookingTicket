class Movie < ApplicationRecord
  has_many :movie_types, dependent: :destroy
  has_many :genres, through: :movie_types
  has_many :shows, dependent: :destroy

  # Validations
  validates :title, presence: true, uniqueness: true, length: { maximum: 255 }
  validates :duration_minutes, presence: true, numericality: { greater_than: 0 }
  validates :status, presence: true, inclusion: { in: ["Now Showing", "Coming Soon"] }
  validates :limit_age, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :screening_day, presence: true
end