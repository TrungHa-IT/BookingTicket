class Room < ApplicationRecord
  belongs_to :cinema

  has_many :seats, dependent: :destroy
  has_many :shows, dependent: :destroy

  # Validations
  validates :name, presence: true,
                   length: { maximum: 100 },
                   uniqueness: { scope: :cinema_id, message: "trong cùng một rạp phải là duy nhất" }

  validates :seat_capacity, presence: true,
                            numericality: { only_integer: true, greater_than: 0 }

  # Scopes
  scope :by_cinema, ->(cinema_id) { where(cinema_id: cinema_id) if cinema_id.present? }
  scope :search, ->(q) {
    if q.present?
      pattern = "%#{ActiveRecord::Base.sanitize_sql_like(q)}%"
      where("name LIKE ?", pattern)
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
