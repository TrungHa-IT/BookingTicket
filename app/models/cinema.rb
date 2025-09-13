class Cinema < ApplicationRecord
  has_many :rooms, dependent: :destroy
  has_many :shows, dependent: :destroy

  # Validations
  validates :name, presence: true,
                   length: { maximum: 100 },
                   uniqueness: { case_sensitive: false }

  validates :address, presence: true,
                      length: { maximum: 255 }
end