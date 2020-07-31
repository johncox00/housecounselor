FactoryBot.define do
  factory :review do
    rating { 3 }
    association :business, factory: :business
    comment { 'average job' }
  end
end
