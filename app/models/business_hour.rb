class BusinessHour < ApplicationRecord
  belongs_to :business
  validates :day, presence: true, inclusion: 0..7, uniqueness: { scope: :business_id }
  validates :open, presence: true, inclusion: 0..23
  validates :close, presence: true, inclusion: 0..23
  validate :open_less_than_close

  attr_accessor :week_day

  before_validation :set_day

  def set_day
    self.day = WEEKDAYS.index(self.week_day) if self.week_day
  end

  def open_less_than_close
    if self.open && self.close && !(self.open < self.close)
      errors.add(:open, "must be before close")
    end
  end
end
