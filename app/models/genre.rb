class Genre < ApplicationRecord
  has_many :movie_types, dependent: :destroy
  has_many :movies, through: :movie_types

  # Validations
  validates :genre_name, presence: true,
                         uniqueness: { case_sensitive: false },
                         length: { maximum: 100 }

  validates :genre_description, presence: true,
                                length: { maximum: 255 }

  # Scopes
  scope :search, ->(q) {
    if q.present?
      pattern = "%#{ActiveRecord::Base.sanitize_sql_like(q)}%"
      where("genre_name LIKE ? OR genre_description LIKE ?", pattern, pattern)
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
