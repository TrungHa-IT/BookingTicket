class CreateMovies < ActiveRecord::Migration[7.2]
  def change
    create_table :movies do |t|
      t.string :title
      t.integer :duration_minutes
      t.string :status
      t.integer :limit_age
      t.date :screening_day

      t.timestamps
    end
  end
end
