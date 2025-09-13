class Movie < ApplicationRecord
  has_many :movie_types, dependent: :destroy
  has_many :genres, through: :movie_types
  has_many :shows, dependent: :destroy

  validates :title, presence: true, uniqueness: true, length: { maximum: 255 }
  validates :duration_minutes, presence: true, numericality: { greater_than: 0 }
  validates :status, presence: true, inclusion: { in: ["Now Showing", "Coming Soon"] }
  validates :limit_age, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :screening_day, presence: true

  scope :by_status, ->(status) { where(status: status) if status.present? }

  scope :by_genre, ->(genre_id) {
    joins(:movie_types).where(movie_types: { genre_id: genre_id }) if genre_id.present?
  }

  scope :search, ->(q) {
    where("title LIKE ?", "%#{sanitize_sql_like(q)}%") if q.present?
  }

  scope :order_by_sort, ->(sort_param) {
    if sort_param.present?
      if sort_param.start_with?('-')
        order("#{sort_param[1..]} DESC")
      else
        order("#{sort_param} ASC")
      end
    else
      order(created_at: :desc)
    end
  }
end
