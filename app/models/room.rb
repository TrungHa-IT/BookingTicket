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
end