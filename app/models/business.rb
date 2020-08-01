class Business < ApplicationRecord
  has_many :reviews
  has_one :address, as: :addressable, dependent: :destroy
  validates :name, presence: true
  accepts_nested_attributes_for :address, update_only: true
end
