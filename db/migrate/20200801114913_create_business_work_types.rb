class CreateBusinessWorkTypes < ActiveRecord::Migration[6.0]
  def change
    create_table :business_work_types do |t|
      t.references :business, null: false, foreign_key: true
      t.references :work_type, null: false, foreign_key: true

      t.timestamps
    end
  end
end
