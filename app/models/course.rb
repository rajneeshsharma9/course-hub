# frozen_string_literal: true

class Course < ApplicationRecord
  # Associations
  has_many :tutors, dependent: :destroy

  # Validations
  validates :name, presence: true

  # Nested attributes
  accepts_nested_attributes_for :tutors
end
