class AddBuffetToUsers < ActiveRecord::Migration[7.1]
  def change
    add_reference :users, :buffet, null: true, foreign_key: true
  end
end
