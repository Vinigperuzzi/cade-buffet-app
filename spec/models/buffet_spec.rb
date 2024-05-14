require 'rails_helper'

RSpec.describe Buffet, type: :model do
  describe '#valid?' do
    it 'must have a name' do
      buffet = Buffet.new(name: '', corporate_name: 'Vinícius Gourmet alimentos', 
        register_number: '12456456000145', phone: '53 991814646', 
        email: 'vinigperuzzi@gourmet.com', address: 'Estrada do Laranjal, 695',
        district: 'Laranjal', state: 'RS', city: 'Pelotas',
        payment_method: 'Pix, Débito, Crédito, Dinheiro',
        description: 'O melhor serviço de buffet do centro de Pelotas')
      
      result = buffet.valid?
      result = buffet.errors.include?(:name)

      expect(result).to be true
      expect(buffet.errors[:name]).to include('não pode ficar em branco')
    end

    it 'must have a corporate name' do
      buffet = Buffet.new(name: 'Vinícius Gourmet', corporate_name: '', 
        register_number: '12456456000145', phone: '53 991814646', 
        email: 'vinigperuzzi@gourmet.com', address: 'Estrada do Laranjal, 695',
        district: 'Laranjal', state: 'RS', city: 'Pelotas',
        payment_method: 'Pix, Débito, Crédito, Dinheiro',
        description: 'O melhor serviço de buffet do centro de Pelotas')
      
      result = buffet.valid?
      result = buffet.errors.include?(:corporate_name)

      expect(result).to be true
      expect(buffet.errors[:corporate_name]).to include('não pode ficar em branco')
    end

    it 'must have a register number' do
      buffet = Buffet.new(name: 'Vinícius Gourmet', corporate_name: 'Vinícius Gourmet alimentos', 
        register_number: '', phone: '53 991814646', 
        email: 'vinigperuzzi@gourmet.com', address: 'Estrada do Laranjal, 695',
        district: 'Laranjal', state: 'RS', city: 'Pelotas',
        payment_method: 'Pix, Débito, Crédito, Dinheiro',
        description: 'O melhor serviço de buffet do centro de Pelotas')
      
      result = buffet.valid?
      result = buffet.errors.include?(:register_number)

      expect(result).to be true
      expect(buffet.errors[:register_number]).to include('não pode ficar em branco')
    end

    it 'must have a phone' do
      buffet = Buffet.new(name: 'Vinícius Gourmet', corporate_name: 'Vinícius Gourmet alimentos', 
        register_number: '12456456000145', phone: '', 
        email: 'vinigperuzzi@gourmet.com', address: 'Estrada do Laranjal, 695',
        district: 'Laranjal', state: 'RS', city: 'Pelotas',
        payment_method: 'Pix, Débito, Crédito, Dinheiro',
        description: 'O melhor serviço de buffet do centro de Pelotas')
      
      result = buffet.valid?
      result = buffet.errors.include?(:phone)

      expect(result).to be true
      expect(buffet.errors[:phone]).to include('não pode ficar em branco')
    end

    it 'must have a email' do
      buffet = Buffet.new(name: 'Vinícius Gourmet', corporate_name: 'Vinícius Gourmet alimentos', 
        register_number: '12456456000145', phone: '53 991814646', 
        email: '', address: 'Estrada do Laranjal, 695',
        district: 'Laranjal', state: 'RS', city: 'Pelotas',
        payment_method: 'Pix, Débito, Crédito, Dinheiro',
        description: 'O melhor serviço de buffet do centro de Pelotas')
      
      result = buffet.valid?
      result = buffet.errors.include?(:email)

      expect(result).to be true
      expect(buffet.errors[:email]).to include('não pode ficar em branco')
    end

    it 'must have a address' do
      buffet = Buffet.new(name: 'Vinícius Gourmet', corporate_name: 'Vinícius Gourmet alimentos', 
        register_number: '12456456000145', phone: '53 991814646', 
        email: 'vinigperuzzi@gourmet.com', address: '',
      district: 'Laranjal', state: 'RS', city: 'Pelotas',
        payment_method: 'Pix, Débito, Crédito, Dinheiro',
        description: 'O melhor serviço de buffet do centro de Pelotas')
      
      result = buffet.valid?
      result = buffet.errors.include?(:address)

      expect(result).to be true
      expect(buffet.errors[:address]).to include('não pode ficar em branco')
    end

    it 'must have a district' do
      buffet = Buffet.new(name: 'Vinícius Gourmet', corporate_name: 'Vinícius Gourmet alimentos', 
        register_number: '12456456000145', phone: '53 991814646', 
        email: 'vinigperuzzi@gourmet.com', address: 'Estrada do Laranjal, 695',
        district: '', state: 'RS', city: 'Pelotas',
        payment_method: 'Pix, Débito, Crédito, Dinheiro',
        description: 'O melhor serviço de buffet do centro de Pelotas')
      
      result = buffet.valid?
      result = buffet.errors.include?(:district)

      expect(result).to be true
      expect(buffet.errors[:district]).to include('não pode ficar em branco')
    end

    it 'must have a state' do
      buffet = Buffet.new(name: 'Vinícius Gourmet', corporate_name: 'Vinícius Gourmet alimentos', 
        register_number: '12456456000145', phone: '53 991814646', 
        email: 'vinigperuzzi@gourmet.com', address: 'Estrada do Laranjal, 695',
        district: 'Laranjal', state: '', city: 'Pelotas',
        payment_method: 'Pix, Débito, Crédito, Dinheiro',
        description: 'O melhor serviço de buffet do centro de Pelotas')
      
      result = buffet.valid?
      result = buffet.errors.include?(:state)

      expect(result).to be true
      expect(buffet.errors[:state]).to include('não pode ficar em branco')
    end

    it 'must have a city' do
      buffet = Buffet.new(name: 'Vinícius Gourmet', corporate_name: 'Vinícius Gourmet alimentos', 
        register_number: '12456456000145', phone: '53 991814646', 
        email: 'vinigperuzzi@gourmet.com', address: 'Estrada do Laranjal, 695',
        district: 'Laranjal', state: 'RS', city: '',
        payment_method: 'Pix, Débito, Crédito, Dinheiro',
        description: 'O melhor serviço de buffet do centro de Pelotas')
      
      result = buffet.valid?
      result = buffet.errors.include?(:city)

      expect(result).to be true
      expect(buffet.errors[:city]).to include('não pode ficar em branco')
    end

    it 'must have a payment method' do
      buffet = Buffet.new(name: 'Vinícius Gourmet', corporate_name: 'Vinícius Gourmet alimentos', 
        register_number: '12456456000145', phone: '53 991814646', 
        email: 'vinigperuzzi@gourmet.com', address: 'Estrada do Laranjal, 695',
        district: 'Laranjal', state: 'RS', city: 'Pelotas',
        payment_method: '',
        description: 'O melhor serviço de buffet do centro de Pelotas')
      
      result = buffet.valid?
      result = buffet.errors.include?(:payment_method)

      expect(result).to be true
      expect(buffet.errors[:payment_method]).to include('não pode ficar em branco')
    end

    it 'must have description' do
      buffet = Buffet.new(name: 'Vinícius Gourmet', corporate_name: 'Vinícius Gourmet alimentos', 
        register_number: '12456456000145', phone: '53 991814646', 
        email: 'vinigperuzzi@gourmet.com', address: 'Estrada do Laranjal, 695',
        district: 'Laranjal', state: 'RS', city: 'Pelotas',
        payment_method: '',
        description: '')
      
      result = buffet.valid?
      result = buffet.errors.include?(:description)

      expect(result).to be true
      expect(buffet.errors[:description]).to include('não pode ficar em branco')
    end
  end
end