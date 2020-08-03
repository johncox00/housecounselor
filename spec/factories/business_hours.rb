FactoryBot.define do
  factory :business_hour do
    open { 9 }
    close { 17 }
    day {1}
    association :business, factory: :business
  end
end
