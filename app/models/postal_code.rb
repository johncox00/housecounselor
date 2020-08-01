class PostalCode < ApplicationRecord
  has_many :city_postal_codes, dependent: :destroy
  has_many :cities, through: :city_postal_codes
  validates :code, uniqueness: true, presence: true
end
