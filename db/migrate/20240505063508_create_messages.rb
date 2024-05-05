class CreateMessages < ActiveRecord::Migration[7.1]
  def change
    create_table :messages do |t|
      t.references :order, null: false, foreign_key: true
      t.integer :sender
      t.boolean :customer_read
      t.boolean :user_read

      t.timestamps
    end
  end
end
