class AddDescriptionToBuffet < ActiveRecord::Migration[7.1]
  def change
    add_column :buffets, :description, :string
  end
end
