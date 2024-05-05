class AddMessageTextToMessage < ActiveRecord::Migration[7.1]
  def change
    add_column :messages, :message_text, :string
  end
end
