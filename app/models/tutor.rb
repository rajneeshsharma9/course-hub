# frozen_string_literal: true
class Tutor < ApplicationRecord
  # Associations
  belongs_to :course, touch: true

  # Validations
  validates :name, presence: true
  validates :email, presence: true
end
