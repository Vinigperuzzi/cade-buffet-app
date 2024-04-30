class AddOutDoorsToOrder < ActiveRecord::Migration[7.1]
  def change
    add_column :orders, :out_doors, :boolean
  end
end
