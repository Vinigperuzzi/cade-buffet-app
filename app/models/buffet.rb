class Buffet < ApplicationRecord
  belongs_to :user, optional: true
  validates :name, :corporate_name, :register_number, :phone, :email, :address, :district, :state, :city, :payment_method, :description, presence: :true
  belongs_to :event, optional: true
end