class CreateBusinesses < ActiveRecord::Migration[6.0]
  def change
    create_table :businesses do |t|
      t.string :name
      t.float :avg_rating, default: 0.0

      t.timestamps
    end
  end
end
