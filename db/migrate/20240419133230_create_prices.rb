class CreatePrices < ActiveRecord::Migration[7.1]
  def change
    create_table :prices do |t|
      t.integer :base_price
      t.integer :additional_person
      t.integer :extra_hour
      t.integer :sp_base_price
      t.integer :sp_additional_person
      t.integer :sp_extra_hour
      t.references :event, null: false, foreign_key: true

      t.timestamps
    end
  end
end
