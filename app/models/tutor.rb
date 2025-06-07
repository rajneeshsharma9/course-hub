# frozen_string_literal: true
class Tutor < ApplicationRecord
  belongs_to :course

  validates :name, presence: true
  validates :email, presence: true
end
