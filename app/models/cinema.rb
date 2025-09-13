class Cinema < ApplicationRecord
  has_many :rooms, dependent: :destroy
  has_many :shows, dependent: :destroy

  # Validations
  validates :name, presence: true,
                   length: { maximum: 100 },
                   uniqueness: { case_sensitive: false }

  validates :address, presence: true,
                      length: { maximum: 255 }

  # Scopes
  scope :search, ->(q) {
    if q.present?
      pattern = "%#{ActiveRecord::Base.sanitize_sql_like(q)}%"
      where("name LIKE ? OR address LIKE ?", pattern, pattern)
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
