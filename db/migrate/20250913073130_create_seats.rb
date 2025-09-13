class CreateSeats < ActiveRecord::Migration[7.2]
  def change
    create_table :seats do |t|
      t.references :room, null: false, foreign_key: true
      t.string :seat_row
      t.integer :seat_number

      t.timestamps
    end
  end
end
