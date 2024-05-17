require 'rails_helper'

RSpec.describe Rate, type: :model do
  describe '#valid?' do
    it 'must have a score' do
      customer = Customer.create!(email: 'cliente@email.com', password: 'password',
        name: 'cliente', cpf: '479.111.310-15')
      user = User.create!(email: 'vinicius@email.com', password: 'password')
      buffet = Buffet.create!(name: 'Vini', corporate_name: 'Vinícius Gourmet alimentos', 
        register_number: '12456456000145', phone: '53 991814646',
        email: 'vinigperuzzi@gourmet.com', address: 'Estrada do Laranjal, 695',
        district: 'Laranjal', state: 'RS', city: 'Pelotas',
        payment_method: 'Pix, Débito, Crédito, Dinheiro',
        description: 'O melhor serviço de buffet do centro de Pelotas')
      user.update!(buffet_id: buffet.id)
      event = Event.create!(name: 'Casamento',
        description: 'Serviço de mesa completo para casamentos',
        min_qtd: 20, max_qtd: 40, duration: 250, menu: 'Frutos do Mar',
        buffet_id: buffet.id)
      price = Price.create!(base_price: 5000, sp_base_price:6000,
        sp_additional_person:500, additional_person:200, sp_extra_hour:30,
        extra_hour:20, event_id: event.id)
      album = Album.create!(event_id: event.id)
      album.images.attach(io: File.open(Rails.root.join('spec', 'support', 'festa_casamento.jpg')), filename: 'festa_casamento.jpg')
      order = Order.create!(buffet_id: buffet.id, event_id: event.id,
        event_date: 1.day.from_now, estimated_qtd: 30,
        event_details: 'Esse evento deve possuir toda a temática com corações rosa',
        address: '', order_status: :confirmed, final_price: 11000, extra_tax: 1000,
        discount: 500, customer_id: customer.id, out_doors: false)
      rate = Rate.new(score: nil, review: "Muito bom",
        customer_id: customer.id, buffet_id: buffet.id)

      result = rate.valid?
      result = rate.errors.include?(:score)

      expect(result).to be true
      expect(rate.errors[:score]).to include('não pode ficar em branco')
    end

    it 'must have a review' do
      customer = Customer.create!(email: 'cliente@email.com', password: 'password',
        name: 'cliente', cpf: '479.111.310-15')
      user = User.create!(email: 'vinicius@email.com', password: 'password')
      buffet = Buffet.create!(name: 'Vini', corporate_name: 'Vinícius Gourmet alimentos', 
        register_number: '12456456000145', phone: '53 991814646',
        email: 'vinigperuzzi@gourmet.com', address: 'Estrada do Laranjal, 695',
        district: 'Laranjal', state: 'RS', city: 'Pelotas',
        payment_method: 'Pix, Débito, Crédito, Dinheiro',
        description: 'O melhor serviço de buffet do centro de Pelotas')
      user.update!(buffet_id: buffet.id)
      event = Event.create!(name: 'Casamento',
        description: 'Serviço de mesa completo para casamentos',
        min_qtd: 20, max_qtd: 40, duration: 250, menu: 'Frutos do Mar',
        buffet_id: buffet.id)
      price = Price.create!(base_price: 5000, sp_base_price:6000,
        sp_additional_person:500, additional_person:200, sp_extra_hour:30,
        extra_hour:20, event_id: event.id)
      album = Album.create!(event_id: event.id)
      album.images.attach(io: File.open(Rails.root.join('spec', 'support', 'festa_casamento.jpg')), filename: 'festa_casamento.jpg')
      order = Order.create!(buffet_id: buffet.id, event_id: event.id,
        event_date: 1.day.from_now, estimated_qtd: 30,
        event_details: 'Esse evento deve possuir toda a temática com corações rosa',
        address: '', order_status: :confirmed, final_price: 11000, extra_tax: 1000,
        discount: 500, customer_id: customer.id, out_doors: false)
      rate = Rate.new(score: 5, review: nil,
        customer_id: customer.id, buffet_id: buffet.id)

      result = rate.valid?
      result = rate.errors.include?(:review)

      expect(result).to be true
      expect(rate.errors[:review]).to include('não pode ficar em branco')
    end

    it 'must have a customer_id' do
      customer = Customer.create!(email: 'cliente@email.com', password: 'password',
        name: 'cliente', cpf: '479.111.310-15')
      user = User.create!(email: 'vinicius@email.com', password: 'password')
      buffet = Buffet.create!(name: 'Vini', corporate_name: 'Vinícius Gourmet alimentos', 
        register_number: '12456456000145', phone: '53 991814646',
        email: 'vinigperuzzi@gourmet.com', address: 'Estrada do Laranjal, 695',
        district: 'Laranjal', state: 'RS', city: 'Pelotas',
        payment_method: 'Pix, Débito, Crédito, Dinheiro',
        description: 'O melhor serviço de buffet do centro de Pelotas')
      user.update!(buffet_id: buffet.id)
      event = Event.create!(name: 'Casamento',
        description: 'Serviço de mesa completo para casamentos',
        min_qtd: 20, max_qtd: 40, duration: 250, menu: 'Frutos do Mar',
        buffet_id: buffet.id)
      price = Price.create!(base_price: 5000, sp_base_price:6000,
        sp_additional_person:500, additional_person:200, sp_extra_hour:30,
        extra_hour:20, event_id: event.id)
      album = Album.create!(event_id: event.id)
      album.images.attach(io: File.open(Rails.root.join('spec', 'support', 'festa_casamento.jpg')), filename: 'festa_casamento.jpg')
      order = Order.create!(buffet_id: buffet.id, event_id: event.id,
        event_date: 1.day.from_now, estimated_qtd: 30,
        event_details: 'Esse evento deve possuir toda a temática com corações rosa',
        address: '', order_status: :confirmed, final_price: 11000, extra_tax: 1000,
        discount: 500, customer_id: customer.id, out_doors: false)
      rate = Rate.new(score: 5, review: "Muito bom",
        customer_id: nil, buffet_id: buffet.id)

      result = rate.valid?
      result = rate.errors.include?(:customer_id)

      expect(result).to be true
      expect(rate.errors[:customer_id]).to include('não pode ficar em branco')
    end

    it 'must have a buffet_id' do
      customer = Customer.create!(email: 'cliente@email.com', password: 'password',
        name: 'cliente', cpf: '479.111.310-15')
      user = User.create!(email: 'vinicius@email.com', password: 'password')
      buffet = Buffet.create!(name: 'Vini', corporate_name: 'Vinícius Gourmet alimentos', 
        register_number: '12456456000145', phone: '53 991814646',
        email: 'vinigperuzzi@gourmet.com', address: 'Estrada do Laranjal, 695',
        district: 'Laranjal', state: 'RS', city: 'Pelotas',
        payment_method: 'Pix, Débito, Crédito, Dinheiro',
        description: 'O melhor serviço de buffet do centro de Pelotas')
      user.update!(buffet_id: buffet.id)
      event = Event.create!(name: 'Casamento',
        description: 'Serviço de mesa completo para casamentos',
        min_qtd: 20, max_qtd: 40, duration: 250, menu: 'Frutos do Mar',
        buffet_id: buffet.id)
      price = Price.create!(base_price: 5000, sp_base_price:6000,
        sp_additional_person:500, additional_person:200, sp_extra_hour:30,
        extra_hour:20, event_id: event.id)
      album = Album.create!(event_id: event.id)
      album.images.attach(io: File.open(Rails.root.join('spec', 'support', 'festa_casamento.jpg')), filename: 'festa_casamento.jpg')
      order = Order.create!(buffet_id: buffet.id, event_id: event.id,
        event_date: 1.day.from_now, estimated_qtd: 30,
        event_details: 'Esse evento deve possuir toda a temática com corações rosa',
        address: '', order_status: :confirmed, final_price: 11000, extra_tax: 1000,
        discount: 500, customer_id: customer.id, out_doors: false)
      rate = Rate.new(score: 5, review: "Muito bom",
        customer_id: customer.id, buffet_id: nil)

      result = rate.valid?
      result = rate.errors.include?(:buffet_id)

      expect(result).to be true
      expect(rate.errors[:buffet_id]).to include('não pode ficar em branco')
    end
  end
end
