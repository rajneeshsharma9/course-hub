# frozen_string_literal: true
# db/seeds.rb
course = Course.create!(name: "Physics", description: "Learn the laws of nature")
3.times do
  Tutor.create!(name: Faker::Name.name, email: Faker::Internet.email, course: course)
end
