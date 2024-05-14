require 'rails_helper'

RSpec.describe Customer, type: :model do
  describe '#valid?' do
    it 'must have a name' do
      customer = Customer.create(email: 'vinicius@email.com', password: 'password',
        name: '', cpf: '03068810043')
      
      result = customer.valid?

      expect(result).to be false
    end

    it 'must have a CPF' do
      customer = Customer.create(email: 'vinicius@email.com', password: 'password',
        name: 'Vinícius', cpf: '')
      
      result = customer.valid?

      expect(result).to be false
    end

    it 'must have a valid CPF' do
      customer = Customer.create(email: 'vinicius@email.com', password: 'password',
        name: 'Vinícius', cpf: '02002002020')
      
      result = customer.valid?

      expect(result).to be false
    end

    it 'must have a unique email' do
      Customer.create!(email: 'vinicius@email.com', password: 'password',
        name: 'Vinícius', cpf: '03068810043')

      customer = Customer.create(email: 'vinicius@email.com', password: 'password2',
        name: 'Débora', cpf: '53539310096')
      
      result = customer.valid?

      expect(result).to be false
    end

    it 'must have a unique CPF' do
      Customer.create!(email: 'vinicius@email.com', password: 'password',
        name: 'Vinícius', cpf: '03068810043')

      customer = Customer.create(email: 'debora@email.com', password: 'password2',
        name: 'Débora', cpf: '03068810043')
      
      result = customer.valid?

      expect(result).to be false
    end
  end
end
