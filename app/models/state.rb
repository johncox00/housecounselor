class State < ApplicationRecord
  has_many :cities
  validates :abbr, presence: true, uniqueness: true
end
