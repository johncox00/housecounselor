class CreateStates < ActiveRecord::Migration[6.0]
  def change
    create_table :states do |t|
      t.string :abbr, unique: true, nil: false

      t.timestamps
    end
  end
end
