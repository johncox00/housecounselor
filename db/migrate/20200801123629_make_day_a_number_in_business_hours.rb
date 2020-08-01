class MakeDayANumberInBusinessHours < ActiveRecord::Migration[6.0]
  def change
    change_column :business_hours, :day, :integer
  end
end
