class CreatePostalCodes < ActiveRecord::Migration[6.0]
  def change
    create_table :postal_codes do |t|
      t.string :code, unique: true, nil: false

      t.timestamps
    end
  end
end
