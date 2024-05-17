class CreateRates < ActiveRecord::Migration[7.1]
  def change
    create_table :rates do |t|
      t.integer :score
      t.string :review
      t.references :buffet, null: false, foreign_key: true
      t.references :customer, null: false, foreign_key: true

      t.timestamps
    end
  end
end
