class CityPostalCode < ApplicationRecord
  belongs_to :city
  belongs_to :postal_code
end
