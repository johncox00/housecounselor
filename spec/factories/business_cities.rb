FactoryBot.define do
  factory :business_city do
    association :business, factory: :business
    association :city, factory: :city
  end
end
