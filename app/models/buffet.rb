class Buffet < ApplicationRecord
  belongs_to :user, optional: true
  validates :name, :corporate_name, :register_number,
            :phone, :email, :address, :district, :state,
            :city, :payment_method, :description, presence: :true
  has_many :events
  has_one :order
  has_one_attached :image
end
