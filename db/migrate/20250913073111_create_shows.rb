class CreateShows < ActiveRecord::Migration[7.2]
  def change
    create_table :shows do |t|
      t.references :movie, null: false, foreign_key: true
      t.references :room, null: false, foreign_key: true
      t.references :cinema, null: false, foreign_key: true
      t.decimal :ticket_price
      t.date :show_day

      t.timestamps
    end
  end
end
