class Order < ApplicationRecord
  belongs_to :buffet
  belongs_to :event
  belongs_to :customer
  enum order_status: { waiting: 0, confirmed: 1, canceled: 2, evaluated: 3 }

  validates :buffet_id, :event_id, :event_date, :estimated_qtd, :event_details,
            :code, :order_status, presence: :true

  before_validation :generate_code, on: :create

  private

  def generate_code
    self.code = SecureRandom.alphanumeric(8).upcase
  end
end
