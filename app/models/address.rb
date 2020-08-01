class Address < ApplicationRecord
  belongs_to :city
  belongs_to :state
  belongs_to :postal_code
  belongs_to :addressable, polymorphic: true
end
