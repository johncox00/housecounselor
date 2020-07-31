class State < ApplicationRecord
  validates :abbr, presence: true, uniqueness: true
end
