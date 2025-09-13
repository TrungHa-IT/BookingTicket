class CreateGenres < ActiveRecord::Migration[7.2]
  def change
    create_table :genres do |t|
      t.string :genre_name
      t.string :genre_description

      t.timestamps
    end
  end
end
