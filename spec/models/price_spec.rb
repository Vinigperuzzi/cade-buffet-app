require 'rails_helper'

RSpec.describe Price, type: :model do
  describe '#valid?' do
    it 'must have a buffet_id' do
      buffet = Buffet.create!(name: 'Vini Gourmet', corporate_name: 'Vinícius Gourmet alimentos', 
        register_number: '12456456000145', phone: '53 991814646',
        email: 'vinigperuzzi@gourmet.com', address: 'Estrada do Laranjal, 695',
        district: 'Laranjal', state: 'RS', city: 'Pelotas',
        payment_method: 'Pix, Débito, Crédito, Dinheiro',
        description: 'O melhor serviço de buffet do centro de Pelotas')
      event = Event.create!(buffet_id: buffet.id, name: 'Casamento',
        description: 'Buffets para casamentos',
        min_qtd: 50, max_qtd:1000, duration: 240, menu: 'Frutos do Mar',
        drinks: true, decoration: true, valet: true)
      price = Price.new(event_id: nil, base_price: 1500, additional_person: 20,
        extra_hour: 500, sp_base_price: 2500,
        sp_additional_person: 30, sp_extra_hour: 30)

      result = price.valid?
      result = price.errors.include?(:event_id)

      expect(result).to be true
      expect(price.errors[:event_id]).to include('não pode ficar em branco')
    end

    it 'must have a base_price' do
      buffet = Buffet.create!(name: 'Vini Gourmet', corporate_name: 'Vinícius Gourmet alimentos', 
        register_number: '12456456000145', phone: '53 991814646',
        email: 'vinigperuzzi@gourmet.com', address: 'Estrada do Laranjal, 695',
        district: 'Laranjal', state: 'RS', city: 'Pelotas',
        payment_method: 'Pix, Débito, Crédito, Dinheiro',
        description: 'O melhor serviço de buffet do centro de Pelotas')
      event = Event.create!(buffet_id: buffet.id, name: 'Casamento',
        description: 'Buffets para casamentos',
        min_qtd: 50, max_qtd:1000, duration: 240, menu: 'Frutos do Mar',
        drinks: true, decoration: true, valet: true)
      price = Price.new(event_id: event.id, base_price: nil, additional_person: 20,
        extra_hour: 500, sp_base_price: 2500,
        sp_additional_person: 30, sp_extra_hour: 30)

      result = price.valid?
      result = price.errors.include?(:base_price)

      expect(result).to be true
      expect(price.errors[:base_price]).to include('não pode ficar em branco')
    end

    it 'must have a additional_person' do
      buffet = Buffet.create!(name: 'Vini Gourmet', corporate_name: 'Vinícius Gourmet alimentos', 
        register_number: '12456456000145', phone: '53 991814646',
        email: 'vinigperuzzi@gourmet.com', address: 'Estrada do Laranjal, 695',
        district: 'Laranjal', state: 'RS', city: 'Pelotas',
        payment_method: 'Pix, Débito, Crédito, Dinheiro',
        description: 'O melhor serviço de buffet do centro de Pelotas')
      event = Event.create!(buffet_id: buffet.id, name: 'Casamento',
        description: 'Buffets para casamentos',
        min_qtd: 50, max_qtd:1000, duration: 240, menu: 'Frutos do Mar',
        drinks: true, decoration: true, valet: true)
      price = Price.new(event_id: event.id, base_price: 2000, additional_person: nil,
        extra_hour: 500, sp_base_price: 2500,
        sp_additional_person: 30, sp_extra_hour: 30)

      result = price.valid?
      result = price.errors.include?(:additional_person)

      expect(result).to be true
      expect(price.errors[:additional_person]).to include('não pode ficar em branco')
    end

    it 'must have a extra_hour' do
      buffet = Buffet.create!(name: 'Vini Gourmet', corporate_name: 'Vinícius Gourmet alimentos', 
        register_number: '12456456000145', phone: '53 991814646',
        email: 'vinigperuzzi@gourmet.com', address: 'Estrada do Laranjal, 695',
        district: 'Laranjal', state: 'RS', city: 'Pelotas',
        payment_method: 'Pix, Débito, Crédito, Dinheiro',
        description: 'O melhor serviço de buffet do centro de Pelotas')
      event = Event.create!(buffet_id: buffet.id, name: 'Casamento',
        description: 'Buffets para casamentos',
        min_qtd: 50, max_qtd:1000, duration: 240, menu: 'Frutos do Mar',
        drinks: true, decoration: true, valet: true)
      price = Price.new(event_id: event.id, base_price: 2000, additional_person: 20,
        extra_hour: nil, sp_base_price: 2500,
        sp_additional_person: 30, sp_extra_hour: 30)

      result = price.valid?
      result = price.errors.include?(:extra_hour)

      expect(result).to be true
      expect(price.errors[:extra_hour]).to include('não pode ficar em branco')
    end

    it 'must have a sp_base_price' do
      buffet = Buffet.create!(name: 'Vini Gourmet', corporate_name: 'Vinícius Gourmet alimentos', 
        register_number: '12456456000145', phone: '53 991814646',
        email: 'vinigperuzzi@gourmet.com', address: 'Estrada do Laranjal, 695',
        district: 'Laranjal', state: 'RS', city: 'Pelotas',
        payment_method: 'Pix, Débito, Crédito, Dinheiro',
        description: 'O melhor serviço de buffet do centro de Pelotas')
      event = Event.create!(buffet_id: buffet.id, name: 'Casamento',
        description: 'Buffets para casamentos',
        min_qtd: 50, max_qtd:1000, duration: 240, menu: 'Frutos do Mar',
        drinks: true, decoration: true, valet: true)
      price = Price.new(event_id: event.id, base_price: 2000, additional_person: 20,
        extra_hour: 500, sp_base_price: nil,
        sp_additional_person: 30, sp_extra_hour: 30)

      result = price.valid?
      result = price.errors.include?(:sp_base_price)

      expect(result).to be true
      expect(price.errors[:sp_base_price]).to include('não pode ficar em branco')
    end

    it 'must have a sp_additional_person' do
      buffet = Buffet.create!(name: 'Vini Gourmet', corporate_name: 'Vinícius Gourmet alimentos', 
        register_number: '12456456000145', phone: '53 991814646',
        email: 'vinigperuzzi@gourmet.com', address: 'Estrada do Laranjal, 695',
        district: 'Laranjal', state: 'RS', city: 'Pelotas',
        payment_method: 'Pix, Débito, Crédito, Dinheiro',
        description: 'O melhor serviço de buffet do centro de Pelotas')
      event = Event.create!(buffet_id: buffet.id, name: 'Casamento',
        description: 'Buffets para casamentos',
        min_qtd: 50, max_qtd:1000, duration: 240, menu: 'Frutos do Mar',
        drinks: true, decoration: true, valet: true)
      price = Price.new(event_id: event.id, base_price: 2000, additional_person: 20,
        extra_hour: 500, sp_base_price: 2500,
        sp_additional_person: nil, sp_extra_hour: 30)

      result = price.valid?
      result = price.errors.include?(:sp_additional_person)

      expect(result).to be true
      expect(price.errors[:sp_additional_person]).to include('não pode ficar em branco')
    end

    it 'must have a sp_extra_hour' do
      buffet = Buffet.create!(name: 'Vini Gourmet', corporate_name: 'Vinícius Gourmet alimentos', 
        register_number: '12456456000145', phone: '53 991814646',
        email: 'vinigperuzzi@gourmet.com', address: 'Estrada do Laranjal, 695',
        district: 'Laranjal', state: 'RS', city: 'Pelotas',
        payment_method: 'Pix, Débito, Crédito, Dinheiro',
        description: 'O melhor serviço de buffet do centro de Pelotas')
      event = Event.create!(buffet_id: buffet.id, name: 'Casamento',
        description: 'Buffets para casamentos',
        min_qtd: 50, max_qtd:1000, duration: 240, menu: 'Frutos do Mar',
        drinks: true, decoration: true, valet: true)
      price = Price.new(event_id: event.id, base_price: 2000, additional_person: 20,
        extra_hour: 500, sp_base_price: 2500,
        sp_additional_person: 30, sp_extra_hour: nil)

      result = price.valid?
      result = price.errors.include?(:sp_extra_hour)

      expect(result).to be true
      expect(price.errors[:sp_extra_hour]).to include('não pode ficar em branco')
    end
  end
end
