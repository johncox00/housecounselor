class BusinessCity < ApplicationRecord
  belongs_to :business
  belongs_to :city

  validates :business, uniqueness: { scope: :city_id }
end
