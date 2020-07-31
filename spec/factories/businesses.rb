FactoryBot.define do
  factory :business do
    sequence :name do |n|
      "Biz_#{n}"
    end
    avg_rating { 0 }
  end
end
