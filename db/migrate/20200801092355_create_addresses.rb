class CreateAddresses < ActiveRecord::Migration[6.0]
  def change
    create_table :addresses do |t|
      t.string :line1
      t.string :line2
      t.references :city, null: false, foreign_key: true
      t.references :state, null: false, foreign_key: true
      t.references :postal_code, null: false, foreign_key: true
      t.references :addressable, polymorphic: true, null: false

      t.timestamps
    end
  end
end
