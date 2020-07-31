class CreateCityPostalCodes < ActiveRecord::Migration[6.0]
  def change
    create_table :city_postal_codes do |t|
      t.references :city, null: false, foreign_key: true
      t.references :postal_code, null: false, foreign_key: true

      t.timestamps
    end
  end
end
