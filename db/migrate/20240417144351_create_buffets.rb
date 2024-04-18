class CreateBuffets < ActiveRecord::Migration[7.1]
  def change
    create_table :buffets do |t|
      t.string :name
      t.string :corporate_name
      t.string :register_number
      t.string :phone
      t.string :email
      t.string :address
      t.string :district
      t.string :state
      t.string :city
      t.string :payment_method

      t.timestamps
    end
  end
end
