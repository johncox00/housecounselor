require 'rails_helper'

RSpec.describe City, type: :model do
  context 'validation' do
    it 'has a valid factory' do
      expect(FactoryBot.build(:city)).to be_valid
    end

    it 'requires a name' do
      expect(FactoryBot.build(:city, name: nil)).to_not be_valid
    end

    it 'only allows one city of the same name in a state' do
      c = FactoryBot.create(:city)
      expect(FactoryBot.build(:city, name: c.name, state: c.state)).to_not be_valid
    end
  end
end
