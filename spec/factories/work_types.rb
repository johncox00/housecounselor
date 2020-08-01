FactoryBot.define do
  factory :work_type do
    sequence :name do |n|
      "wt#{n}"
    end
  end
end
