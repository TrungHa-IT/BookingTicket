# db/seeds.rb
require "faker"

puts "Seeding database..."

# ===== Users =====
puts "Seeding Users..."
10.times do
  User.create!(
    fullname: Faker::Name.name,
    email: Faker::Internet.unique.email,
    phone: Faker::Number.unique.number(digits: 10).to_s,
    password_hash: "123456",
    role: [0, 1].sample
  )
end

# ===== Cinemas =====
puts "Seeding Cinemas..."
10.times do
  Cinema.create!(
    name: Faker::Company.name,
    address: Faker::Address.full_address
  )
end

# ===== Rooms =====
puts "Seeding Rooms..."
Cinema.all.each do |cinema|
  existing_names = []
  2.times do
    # Sinh name chưa tồn tại trong cinema này
    name = Faker::Commerce.department(max: 1, fixed_amount: true)
    while existing_names.include?(name)
      name = Faker::Commerce.department(max: 1, fixed_amount: true)
    end
    existing_names << name

    Room.create!(
      cinema: cinema,
      name: name,
      seat_capacity: rand(20..50)
    )
  end
end

# ===== Genres =====
puts "Seeding Genres..."
existing_genres = []
10.times do
  genre_name = Faker::Book.genre
  while existing_genres.include?(genre_name)
    genre_name = Faker::Book.genre
  end
  existing_genres << genre_name

  Genre.create!(
    genre_name: genre_name,
    genre_description: Faker::Lorem.sentence
  )
end

# ===== Genres =====
puts "Seeding Genres..."
10.times do
  # Nếu trùng tên, không tạo mới
  Genre.find_or_create_by!(genre_name: Faker::Book.genre) do |g|
    g.genre_description = Faker::Lorem.sentence
  end
end

# ===== Movies =====
puts "Seeding Movies..."
10.times do
  Faker::UniqueGenerator.clear
  Movie.create!(
    title: Faker::Movie.title,
    duration_minutes: rand(80..180),
    status: ["Now Showing", "Coming Soon"].sample,
    limit_age: [0, 13, 16, 18].sample,
    screening_day: Faker::Date.forward(days: 30)
  )
end

# ===== MovieTypes =====
puts "Seeding MovieTypes..."
Movie.all.each do |movie|
  Genre.all.sample(2).each do |genre|
    MovieType.create!(
      movie: movie,
      genre: genre
    )
  end
end

# ===== Shows =====
puts "Seeding Shows..."
10.times do
  Show.create!(
    movie: Movie.all.sample,
    room: Room.all.sample,
    cinema: Cinema.all.sample,
    ticket_price: rand(50..200),
    show_day: Faker::Date.forward(days: 30)
  )
end

# ===== ShowTimeDetails =====
puts "Seeding ShowTimeDetails..."
Show.all.each do |show|
  2.times do
    start_time = Faker::Time.forward(days: 30, period: :morning)
    end_time = start_time + rand(1..3).hours
    ShowTimeDetail.create!(
      show: show,
      start_time: start_time,
      end_time: end_time
    )
  end
end

# ===== SeatShowTimeDetails =====
puts "Seeding SeatShowTimeDetails..."
ShowTimeDetail.all.each do |std|
  Seat.all.sample(10).each do |seat|
    SeatShowTimeDetail.create!(
      show_time_detail: std,
      seat: seat,
      status: ["Available", "Booked", "Held"].sample
    )
  end
end

# ===== Bookings =====
puts "Seeding Bookings..."
10.times do
  Booking.create!(
    user: User.all.sample,
    show: Show.all.sample,
    booking_time: Faker::Time.backward(days: 5),
    total_amount: rand(100..500)
  )
end

# ===== BookingSeats =====
puts "Seeding BookingSeats..."
Booking.all.each do |booking|
  Seat.all.sample(3).each do |seat|
    BookingSeat.create!(
      booking: booking,
      seat: seat,
      show_time_detail: ShowTimeDetail.all.sample,
      hold_still: [true, false].sample
    )
  end
end

# ===== Payments =====
puts "Seeding Payments..."
Booking.all.each do |booking|
  Payment.create!(
    booking: booking,
    payment_method: ["Credit Card", "Cash", "PayPal"].sample,
    amount: booking.total_amount,
    payment_date: Faker::Time.backward(days: 5),
    status: ["Success", "Pending", "Failed"].sample
  )
end

puts "Seeding completed!"
