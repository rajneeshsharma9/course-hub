# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Tutor, type: :model do
  describe 'associations' do
    it { should belong_to(:course) }
  end

  describe 'validations' do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:email) }
  end

  describe 'factory' do
    it 'has a valid factory' do
      expect(build(:tutor)).to be_valid
    end
  end
end
