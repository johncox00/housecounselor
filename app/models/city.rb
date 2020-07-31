class City < ApplicationRecord
  has_many :city_postal_codes
  has_many :postal_codes, through: :city_postal_codes
  validates :name, presence: true
end
