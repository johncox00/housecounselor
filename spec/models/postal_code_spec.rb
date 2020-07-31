require 'rails_helper'

RSpec.describe PostalCode, type: :model do
  context 'validation' do
    it 'has a valid factory' do
      expect(FactoryBot.build(:postal_code)).to be_valid
    end

    it 'requires a code' do
      expect(FactoryBot.build(:postal_code, code: nil)).to_not be_valid
    end

    it 'requires the code to be unique' do
      c = FactoryBot.create(:postal_code)
      expect(FactoryBot.build(:postal_code, code: c.code)).to_not be_valid
    end
  end
end
