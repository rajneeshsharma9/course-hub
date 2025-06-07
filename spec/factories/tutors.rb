# frozen_string_literal: true
FactoryBot.define do
  factory :tutor do
    name { Faker::Name.name }
    email { Faker::Internet.email }
    course
  end
end
