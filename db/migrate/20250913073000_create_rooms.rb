class CreateRooms < ActiveRecord::Migration[7.2]
  def change
    create_table :rooms do |t|
      t.references :cinema, null: false, foreign_key: true
      t.string :name
      t.integer :seat_capacity

      t.timestamps
    end
  end
end
