class Price < ApplicationRecord
  has_one :event
  validates :event_id, :base_price, :additional_person,
            :extra_hour, :sp_base_price, :sp_additional_person,
            :sp_extra_hour, presence: :true
end
