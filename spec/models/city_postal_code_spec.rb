require 'rails_helper'

RSpec.describe City, type: :model do
  it 'facilitates a city having many postal codes' do
    c = FactoryBot.create(:city)
    z1 = FactoryBot.create(:postal_code)
    z2 = FactoryBot.create(:postal_code)
    c.postal_codes << z1
    c.postal_codes << z2
    expect(c.reload.postal_codes.length).to eq(2)
  end

  it 'facilitates a postal code having many cities' do
    c1 = FactoryBot.create(:city)
    c2 = FactoryBot.create(:city)
    z = FactoryBot.create(:postal_code)
    z.cities << c1
    z.cities << c2
    expect(z.reload.cities.length).to eq(2)
  end
end
