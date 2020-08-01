class BusinessWorkType < ApplicationRecord
  belongs_to :business
  belongs_to :work_type
  validates :work_type, uniqueness: { scope: :business_id }
end
