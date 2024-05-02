class AddTaxDiscountDescriptionsAndPaymentMethodToOrder < ActiveRecord::Migration[7.1]
  def change
    add_column :orders, :tax_description, :string
    add_column :orders, :discount_description, :string
    add_column :orders, :payment_method, :string
  end
end
