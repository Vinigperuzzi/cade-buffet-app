class Rate < ApplicationRecord
  belongs_to :buffet
  belongs_to :customer
  has_one :order, through: :customer
  has_many_attached :images

  validates :score, :review, :customer_id, :buffet_id, presence: :true

  validate :score_is_valid?

  private

  def score_is_valid?
    if self.score.present? and self.score < 1
      self.errors.add(:score, " não pode ser menor do que 1")
    end
    if self.score.present? and self.score > 5
      self.errors.add(:score, " não pode ser maior do que 5")
    end
  end
end
