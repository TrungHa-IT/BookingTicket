class Show < ApplicationRecord
  belongs_to :movie
  belongs_to :room
  belongs_to :cinema

  has_many :show_time_details, dependent: :destroy
  has_many :bookings, dependent: :destroy

  # Validations
  validates :ticket_price, presence: true, numericality: { greater_than: 0 }
  validates :show_day, presence: true

  # Scopes
  scope :by_movie, ->(movie_id) { where(movie_id: movie_id) if movie_id.present? }
  scope :by_cinema, ->(cinema_id) { where(cinema_id: cinema_id) if cinema_id.present? }
  scope :by_room, ->(room_id) { where(room_id: room_id) if room_id.present? }
  scope :search, ->(q) {
    if q.present?
      pattern = "%#{ActiveRecord::Base.sanitize_sql_like(q)}%"
      joins(:movie).where("movies.title LIKE ?", pattern)
    end
  }
  scope :sorted, ->(sort) {
    if sort.present?
      if sort.start_with?('-')
        order("#{sort[1..]} DESC")
      else
        order("#{sort} ASC")
      end
    else
      order(created_at: :desc)
    end
  }
end
