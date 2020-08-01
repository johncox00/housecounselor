class WorkType < ApplicationRecord
  validates :name, presence: true, uniqueness: true
end
