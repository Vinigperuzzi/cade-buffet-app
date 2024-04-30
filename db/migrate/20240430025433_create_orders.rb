class CreateOrders < ActiveRecord::Migration[7.1]
  def change
    create_table :orders do |t|
      t.references :buffet, null: false, foreign_key: true
      t.references :event, null: false, foreign_key: true
      t.date :event_date
      t.integer :estimated_qtd
      t.string :event_details
      t.string :code,                   default: "0"
      t.string :address
      t.integer :order_status
      t.integer :final_price
      t.date :payment_final_date
      t.integer :extra_tax
      t.integer :discount

      t.timestamps
    end

    add_index :orders, :code,           unique: true
  end
end
