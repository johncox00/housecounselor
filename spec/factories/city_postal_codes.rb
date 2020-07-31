FactoryBot.define do
  factory :city_postal_code do
    association :postal_code, factory: :postal_code
    association :city, factory: :city
  end
end
