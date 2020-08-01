class WorkType < ApplicationRecord
  has_many :business_work_types
  has_many :businesses, through: :business_work_types
  validates :name, presence: true, uniqueness: true
end
