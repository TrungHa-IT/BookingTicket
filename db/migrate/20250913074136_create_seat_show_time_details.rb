class CreateSeatShowTimeDetails < ActiveRecord::Migration[7.2]
  def change
    create_table :seat_show_time_details do |t|
      t.references :show_time_detail, null: false, foreign_key: true
      t.references :seat, null: false, foreign_key: true
      t.string :status

      t.timestamps
    end
  end
end
