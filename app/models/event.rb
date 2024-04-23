class Event < ApplicationRecord
  belongs_to :buffet, optional: true
  validates :name, :description, :min_qtd, :max_qtd, :duration, :menu, presence: :true
  has_many :prices
end
