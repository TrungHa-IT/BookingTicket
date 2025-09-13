class CreateBookingSeats < ActiveRecord::Migration[7.2]
  def change
    create_table :booking_seats do |t|
      t.references :booking, null: false, foreign_key: true
      t.references :seat, null: false, foreign_key: true
      t.references :show_time_detail, null: false, foreign_key: true
      t.boolean :hold_still

      t.timestamps
    end
  end
end
