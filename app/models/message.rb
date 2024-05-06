class Message < ApplicationRecord
  belongs_to :order
  enum sender: {customer: 0, user: 1}
end
