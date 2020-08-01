FactoryBot.define do
  factory :state do
    sequence :abbr do |n|
      "ST#{n}"
    end
  end
end
