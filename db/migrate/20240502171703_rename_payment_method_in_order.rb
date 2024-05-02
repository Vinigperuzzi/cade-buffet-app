class RenamePaymentMethodInOrder < ActiveRecord::Migration[7.1]
  def change
    rename_column :orders, :payment_method, :payment_form
  end
end
