class Business < ApplicationRecord
  has_many :reviews
  has_one :address, as: :addressable, dependent: :destroy
  has_many :business_work_types
  has_many :work_types, through: :business_work_types
  validates :name, presence: true
  accepts_nested_attributes_for :address, update_only: true
end
