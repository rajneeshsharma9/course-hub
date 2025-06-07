# frozen_string_literal: true
require 'rails_helper'

RSpec.describe Course, type: :model do
  describe 'validations' do
    it { should have_many(:tutors).dependent(:destroy) }
  end
end
