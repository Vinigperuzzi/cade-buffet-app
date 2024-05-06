class Order < ApplicationRecord
  belongs_to :buffet
  belongs_to :event
  belongs_to :customer
  has_many :messages
  enum order_status: { waiting: 0, confirmed: 1, canceled: 2, evaluated: 3 }

  validates :buffet_id, :event_id, :event_date, :estimated_qtd, :event_details,
            :code, :order_status, presence: :true

  validate :event_date_is_future?, :payment_final_date_is_future?,
            :qtd_people_within_max_qtd?

  before_validation :generate_code, on: :create

  private

  def generate_code
    self.code = SecureRandom.alphanumeric(8).upcase
  end

  def event_date_is_future?
    if self.event_date.present? and self.event_date < Date.today
      self.errors.add(:event_date, " deve ser futura")
    end
  end

  def payment_final_date_is_future?
    if self.payment_final_date.present? and self.payment_final_date < Date.today
      self.errors.add(:payment_final_date, " deve ser futura")
    end
  end

  def qtd_people_within_max_qtd?
    if self.event_id.present?
      @event = Event.find(self.event_id)
      if self.estimated_qtd.present? and self.estimated_qtd > @event.max_qtd
        message = " não pode ser maior do que a quantidade máxima do evento"
        self.errors.add(:estimated_qtd, message)
      end
    end
  end
end
