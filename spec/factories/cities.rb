FactoryBot.define do
  factory :city do
    name { "Anaheim" }
    association :state, factory: :state
  end

end
