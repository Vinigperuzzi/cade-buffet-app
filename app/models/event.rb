class Event < ApplicationRecord
  belongs_to :buffet, optional: true
  validates :buffet_id, :name, :description, :min_qtd,
            :max_qtd, :duration, :menu, presence: :true
  has_many :prices
  has_one :album
  has_one :price
end
