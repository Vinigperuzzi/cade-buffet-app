class Event < ApplicationRecord
  has_one :buffet
  validates :name, :description, :min_qtd, :max_qtd, :duration, :menu, presence: :true
  belongs_to :price, optional: true
end
