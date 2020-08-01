class CreateBusinessCities < ActiveRecord::Migration[6.0]
  def change
    create_table :business_cities do |t|
      t.references :business, null: false, foreign_key: true
      t.references :city, null: false, foreign_key: true

      t.timestamps
    end
  end
end
