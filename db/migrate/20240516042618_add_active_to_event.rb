class AddActiveToEvent < ActiveRecord::Migration[7.1]
  def change
    add_column :events, :active, :boolean, default: true
  end
end
