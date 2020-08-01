class City < ApplicationRecord
  has_many :city_postal_codes, dependent: :destroy
  has_many :postal_codes, through: :city_postal_codes
  belongs_to :state
  has_many :business_cities
  has_many :businesses, through: :business_cities
  validates :name, presence: true, uniqueness: { scope: :state_id }
end
