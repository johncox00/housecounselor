FactoryBot.define do
  factory :address do
    line1 { '123 Town Center Blvd' }
    line2 { 'Suite 31' }
    association :city, factory: :city
    association :postal_code, factory: :postal_code
    association :state, factory: :state
  end
end
