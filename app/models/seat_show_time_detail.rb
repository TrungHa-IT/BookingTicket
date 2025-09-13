class SeatShowTimeDetail < ApplicationRecord
  belongs_to :show_time_detail
  belongs_to :seat

  # Validations
  validates :status, presence: true, inclusion: { in: ["Available", "Booked", "Held"] }

  # Một seat trong 1 show_time_detail chỉ được có 1 record
  validates :seat_id, uniqueness: { scope: :show_time_detail_id,
                                    message: "Ghế này đã tồn tại trong suất chiếu" }

  # Scopes
  scope :by_show_time_detail, ->(std_id) { where(show_time_detail_id: std_id) if std_id.present? }
  scope :by_seat, ->(seat_id) { where(seat_id: seat_id) if seat_id.present? }
  scope :by_status, ->(status) { where(status: status) if status.present? }
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
