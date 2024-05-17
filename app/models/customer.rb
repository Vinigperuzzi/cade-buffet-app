class Customer < ApplicationRecord
  require "cpf_cnpj"
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :orders
  has_one :rate

  validates :name, :cpf, presence: :true
  validates :cpf, uniqueness: :true
  validate :validate_cpf

  def validate_cpf
    if self.cpf.present? and not CPF.valid?(self.cpf)
      self.errors.add(:cpf, ' deve ser válido')
    end
  end
end
