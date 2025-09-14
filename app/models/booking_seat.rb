class BookingSeat < ApplicationRecord
  belongs_to :booking
  belongs_to :seat
  belongs_to :show_time_detail

  # Validations
  validates :hold_still, inclusion: { in: [true, false] }

  # Scopes
  scope :by_booking, ->(booking_id) { where(booking_id: booking_id) if booking_id.present? }
  scope :by_show_time_detail, ->(show_time_detail_id) { where(show_time_detail_id: show_time_detail_id) if show_time_detail_id.present? }
  scope :by_hold_still, ->(hold_still) { where(hold_still: hold_still) unless hold_still.nil? }

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
