class BusinessHour < ApplicationRecord
  belongs_to :business
  validates :day, presence: true, inclusion: 0..7, uniqueness: { scope: :business_id }
  validates :open, presence: true
  validates :close, presence: true

  attr_accessor :week_day

  before_validation :set_day

  def set_day
    self.day = WEEKDAYS.index(self.week_day) if self.week_day
  end
end
