class CreateBusinessHours < ActiveRecord::Migration[6.0]
  def change
    create_table :business_hours do |t|
      t.string :day
      t.integer :open
      t.integer :close
      t.references :business, null: false, foreign_key: true

      t.timestamps
    end
  end
end
