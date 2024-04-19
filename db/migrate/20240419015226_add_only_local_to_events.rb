class AddOnlyLocalToEvents < ActiveRecord::Migration[7.1]
  def change
    add_column :events, :only_local, :boolean
  end
end
