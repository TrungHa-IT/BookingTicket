# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.2].define(version: 2025_09_13_074136) do
  create_table "booking_seats", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "booking_id", null: false
    t.bigint "seat_id", null: false
    t.bigint "show_time_detail_id", null: false
    t.boolean "hold_still"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["booking_id"], name: "index_booking_seats_on_booking_id"
    t.index ["seat_id"], name: "index_booking_seats_on_seat_id"
    t.index ["show_time_detail_id"], name: "index_booking_seats_on_show_time_detail_id"
  end

  create_table "bookings", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "show_id", null: false
    t.datetime "booking_time"
    t.decimal "total_amount", precision: 10
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["show_id"], name: "index_bookings_on_show_id"
    t.index ["user_id"], name: "index_bookings_on_user_id"
  end

  create_table "cinemas", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "name"
    t.string "address"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "genres", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "genre_name"
    t.string "genre_description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "movie_types", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "movie_id", null: false
    t.bigint "genre_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["genre_id"], name: "index_movie_types_on_genre_id"
    t.index ["movie_id"], name: "index_movie_types_on_movie_id"
  end

  create_table "movies", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "title"
    t.integer "duration_minutes"
    t.string "status"
    t.integer "limit_age"
    t.date "screening_day"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "payments", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "booking_id", null: false
    t.string "payment_method"
    t.decimal "amount", precision: 10
    t.datetime "payment_date"
    t.string "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["booking_id"], name: "index_payments_on_booking_id"
  end

  create_table "rooms", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "cinema_id", null: false
    t.string "name"
    t.integer "seat_capacity"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["cinema_id"], name: "index_rooms_on_cinema_id"
  end

  create_table "seat_show_time_details", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "show_time_detail_id", null: false
    t.bigint "seat_id", null: false
    t.string "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["seat_id"], name: "index_seat_show_time_details_on_seat_id"
    t.index ["show_time_detail_id"], name: "index_seat_show_time_details_on_show_time_detail_id"
  end

  create_table "seats", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "room_id", null: false
    t.string "seat_row"
    t.integer "seat_number"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["room_id"], name: "index_seats_on_room_id"
  end

  create_table "show_time_details", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "show_id", null: false
    t.datetime "start_time"
    t.datetime "end_time"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["show_id"], name: "index_show_time_details_on_show_id"
  end

  create_table "shows", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "movie_id", null: false
    t.bigint "room_id", null: false
    t.bigint "cinema_id", null: false
    t.decimal "ticket_price", precision: 10
    t.date "show_day"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["cinema_id"], name: "index_shows_on_cinema_id"
    t.index ["movie_id"], name: "index_shows_on_movie_id"
    t.index ["room_id"], name: "index_shows_on_room_id"
  end

  create_table "users", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "fullname"
    t.string "email"
    t.string "phone"
    t.string "password_hash"
    t.integer "role"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["phone"], name: "index_users_on_phone", unique: true
  end

  add_foreign_key "booking_seats", "bookings"
  add_foreign_key "booking_seats", "seats"
  add_foreign_key "booking_seats", "show_time_details"
  add_foreign_key "bookings", "shows"
  add_foreign_key "bookings", "users"
  add_foreign_key "movie_types", "genres"
  add_foreign_key "movie_types", "movies"
  add_foreign_key "payments", "bookings"
  add_foreign_key "rooms", "cinemas"
  add_foreign_key "seat_show_time_details", "seats"
  add_foreign_key "seat_show_time_details", "show_time_details"
  add_foreign_key "seats", "rooms"
  add_foreign_key "show_time_details", "shows"
  add_foreign_key "shows", "cinemas"
  add_foreign_key "shows", "movies"
  add_foreign_key "shows", "rooms"
end
