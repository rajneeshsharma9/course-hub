class Course < ApplicationRecord
  has_many :tutors, dependent: :destroy
end
