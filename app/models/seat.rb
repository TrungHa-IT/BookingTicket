class Seat < ApplicationRecord
  belongs_to :room
  has_many :booking_seats, dependent: :destroy

  # Validations
  validates :seat_number, presence: true, numericality: { only_integer: true, greater_than: 0 }
  validates :seat_row, presence: true, length: { maximum: 5 }
  validates :room_id, presence: true
  validates :seat_number, uniqueness: { scope: [:seat_row, :room_id],
                                        message: "Ghế đã tồn tại trong phòng" }

  # Scopes
  scope :by_room, ->(room_id) { where(room_id: room_id) if room_id.present? }
  scope :search, ->(q) {
    if q.present?
      pattern = "%#{ActiveRecord::Base.sanitize_sql_like(q)}%"
      where("seat_row LIKE ? OR CAST(seat_number AS TEXT) LIKE ?", pattern, pattern)
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
