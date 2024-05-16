class Rate < ApplicationRecord
  belongs_to :buffet
  belongs_to :customer
  has_many_attached :images
end
