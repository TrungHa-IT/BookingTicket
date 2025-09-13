class CreateShowTimeDetails < ActiveRecord::Migration[7.2]
  def change
    create_table :show_time_details do |t|
      t.references :show, null: false, foreign_key: true
      t.datetime :start_time
      t.datetime :end_time

      t.timestamps
    end
  end
end
