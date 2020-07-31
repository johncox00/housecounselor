require 'rails_helper'

RSpec.describe Business, type: :model do
  context 'validation' do
    it 'has a valid factory' do
      expect(FactoryBot.build(:business)).to be_valid
    end

    it 'requires a name' do
      expect(FactoryBot.build(:business, name: nil)).to_not be_valid
    end
  end
end
