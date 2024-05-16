class AddActiveToBuffet < ActiveRecord::Migration[7.1]
  def change
    add_column :buffets, :active, :boolean, default: true
  end
end
