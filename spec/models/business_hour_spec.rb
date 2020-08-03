require 'rails_helper'

RSpec.describe BusinessHour, type: :model do
  context 'validation' do
    it 'has a valid factory' do
      expect(FactoryBot.build(:business_hour)).to be_valid
    end

    it 'requires a day' do
      expect(FactoryBot.build(:business_hour, day: nil)).to_not be_valid
    end

    it 'requires an open' do
      expect(FactoryBot.build(:business_hour, open: nil)).to_not be_valid
    end

    it 'requires a close' do
      expect(FactoryBot.build(:business_hour, close: nil)).to_not be_valid
    end

    it 'only allows actual days of the week' do
      expect(FactoryBot.build(:business_hour, day: 8)).to_not be_valid
    end

    it 'does not allow multiple business hours for the same day' do
      h = FactoryBot.create(:business_hour)
      expect(FactoryBot.build(:business_hour, business: h.business, day: h.day)).to_not be_valid
    end

    it 'requires open to be before close' do
      expect(FactoryBot.build(:business_hour, open: 12, close: 11)).to_not be_valid
    end

    it 'requires open and close to be in the valid range' do
      expect(FactoryBot.build(:business_hour, open: -1)).to_not be_valid
      expect(FactoryBot.build(:business_hour, open: 24, close: 25)).to_not be_valid
      expect(FactoryBot.build(:business_hour, open: -2, close: -1)).to_not be_valid
      expect(FactoryBot.build(:business_hour, close: 24)).to_not be_valid
      (0..22).each do |h|
        expect(FactoryBot.build(:business_hour, open: h, close: h+1)).to be_valid
      end
    end
  end

  it 'sets the day by string week day value' do
    h = FactoryBot.build(:business_hour, day: nil)
    expect(h.day).to be_nil
    h.week_day = 'Monday'
    h.save
    expect(h.day).to eq(1)
  end
end
