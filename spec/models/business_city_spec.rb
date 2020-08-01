require 'rails_helper'

RSpec.describe BusinessCity, type: :model do
  it 'facilitates a city having many businesses' do
    c = FactoryBot.create(:city)
    b1 = FactoryBot.create(:business)
    b2 = FactoryBot.create(:business)
    c.businesses << b1
    c.businesses << b2
    expect(c.reload.businesses.length).to eq(2)
  end

  it 'facilitates a business having many cities' do
    c1 = FactoryBot.create(:city)
    c2 = FactoryBot.create(:city)
    b = FactoryBot.create(:business)
    b.cities << c1
    b.cities << c2
    expect(b.reload.cities.length).to eq(2)
  end

  it 'disallows a business-city combination from happening more than once' do
    bc = FactoryBot.create(:business_city)
    expect(FactoryBot.build(:business_city, city: bc.city, business: bc.business)).to_not be_valid
  end
end
