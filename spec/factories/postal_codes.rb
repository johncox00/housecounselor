FactoryBot.define do
  factory :postal_code do
    sequence :code do |n|
      "'%05d' % #{n}"
    end
  end
end
