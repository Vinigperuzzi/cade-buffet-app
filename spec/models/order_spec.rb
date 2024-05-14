require 'rails_helper'

RSpec.describe Order, type: :model do
  describe '#valid?' do
    it 'must have a buffet id' do
      buffet = Buffet.create!(name: 'Vini Gourmet',
        corporate_name: 'Vinícius Gourmet alimentos', 
        register_number: '12456456000145', phone: '53 991814646',
        email: 'vinigperuzzi@gourmet.com', address: 'Estrada do Laranjal, 695',
        district: 'Laranjal', state: 'RS', city: 'Pelotas',
        payment_method: 'Pix, Débito, Crédito, Dinheiro',
        description: 'O melhor serviço de buffet do centro de Pelotas')
      event = Event.create!(buffet_id: buffet.id, name: 'Casamento',
        description: 'Buffets para casamentos',
        min_qtd: 50, max_qtd:1000, duration: 240, menu: 'Frutos do Mar',
        drinks: true, decoration: true, valet: true)
      customer = Customer.create!(email: 'cliente@email.com', password: 'password',
        name: 'cliente', cpf: '479.111.310-15')
      order = Order.new(buffet_id: nil, event_id: event.id,
        event_date: 1.day.from_now, estimated_qtd: 200,
        event_details: 'Esse evento deve possuir toda a temática com corações rosa',
        address: '', order_status: :waiting, final_price: nil, extra_tax: nil,
        discount: nil, customer_id: customer.id, out_doors: false)
      result = order.valid?
      result = order.errors.include?(:buffet_id)

      expect(result).to be true
      expect(order.errors[:buffet_id]).to include('não pode ficar em branco')
    end

    it 'must have an event id' do
      buffet = Buffet.create!(name: 'Vini Gourmet',
        corporate_name: 'Vinícius Gourmet alimentos', 
        register_number: '12456456000145', phone: '53 991814646',
        email: 'vinigperuzzi@gourmet.com', address: 'Estrada do Laranjal, 695',
        district: 'Laranjal', state: 'RS', city: 'Pelotas',
        payment_method: 'Pix, Débito, Crédito, Dinheiro',
        description: 'O melhor serviço de buffet do centro de Pelotas')
      event = Event.create!(buffet_id: buffet.id, name: 'Casamento',
        description: 'Buffets para casamentos',
        min_qtd: 200, max_qtd:1000, duration: 240, menu: 'Frutos do Mar',
        drinks: true, decoration: true, valet: true)
      customer = Customer.create!(email: 'cliente@email.com', password: 'password',
        name: 'cliente', cpf: '479.111.310-15')
      order = Order.new(buffet_id: buffet.id, event_id: nil,
        event_date: 1.day.from_now, estimated_qtd: 50,
        event_details: 'Esse evento deve possuir toda a temática com corações rosa',
        address: '', order_status: :waiting, final_price: nil, extra_tax: nil,
        discount: nil, customer_id: customer.id, out_doors: false)
      result = order.valid?
      result = order.errors.include?(:event_id)

      expect(result).to be true
      expect(order.errors[:event_id]).to include('não pode ficar em branco')
    end

    it 'must have an event date' do
      buffet = Buffet.create!(name: 'Vini Gourmet',
        corporate_name: 'Vinícius Gourmet alimentos', 
        register_number: '12456456000145', phone: '53 991814646',
        email: 'vinigperuzzi@gourmet.com', address: 'Estrada do Laranjal, 695',
        district: 'Laranjal', state: 'RS', city: 'Pelotas',
        payment_method: 'Pix, Débito, Crédito, Dinheiro',
        description: 'O melhor serviço de buffet do centro de Pelotas')
      event = Event.create!(buffet_id: buffet.id, name: 'Casamento',
        description: 'Buffets para casamentos',
        min_qtd: 50, max_qtd:1000, duration: 240, menu: 'Frutos do Mar',
        drinks: true, decoration: true, valet: true)
      customer = Customer.create!(email: 'cliente@email.com', password: 'password',
        name: 'cliente', cpf: '479.111.310-15')
      order = Order.new(buffet_id: buffet.id, event_id: event.id,
        event_date: nil, estimated_qtd: 200,
        event_details: 'Esse evento deve possuir toda a temática com corações rosa',
        address: '', order_status: :waiting, final_price: nil, extra_tax: nil,
        discount: nil, customer_id: customer.id, out_doors: false)
      result = order.valid?
      result = order.errors.include?(:event_date)

      expect(result).to be true
      expect(order.errors[:event_date]).to include('não pode ficar em branco')
    end

    it 'and event date id must be future' do
      buffet = Buffet.create!(name: 'Vini Gourmet',
        corporate_name: 'Vinícius Gourmet alimentos', 
        register_number: '12456456000145', phone: '53 991814646',
        email: 'vinigperuzzi@gourmet.com', address: 'Estrada do Laranjal, 695',
        district: 'Laranjal', state: 'RS', city: 'Pelotas',
        payment_method: 'Pix, Débito, Crédito, Dinheiro',
        description: 'O melhor serviço de buffet do centro de Pelotas')
      event = Event.create!(buffet_id: buffet.id, name: 'Casamento',
        description: 'Buffets para casamentos',
        min_qtd: 50, max_qtd:1000, duration: 240, menu: 'Frutos do Mar',
        drinks: true, decoration: true, valet: true)
      customer = Customer.create!(email: 'cliente@email.com', password: 'password',
        name: 'cliente', cpf: '479.111.310-15')
      order = Order.new(buffet_id: buffet.id, event_id: event.id,
        event_date: Date.new(2024, 5, 1), estimated_qtd: 200,
        event_details: 'Esse evento deve possuir toda a temática com corações rosa',
        address: '', order_status: :waiting, final_price: nil, extra_tax: nil,
        discount: nil, customer_id: customer.id, out_doors: false)
      result = order.valid?
      result = order.errors.include?(:event_date)

      expect(result).to be true
      expect(order.errors[:event_date]).to include(' deve ser futura')
    end

    it 'and payment date id must be future' do
      buffet = Buffet.create!(name: 'Vini Gourmet',
        corporate_name: 'Vinícius Gourmet alimentos', 
        register_number: '12456456000145', phone: '53 991814646',
        email: 'vinigperuzzi@gourmet.com', address: 'Estrada do Laranjal, 695',
        district: 'Laranjal', state: 'RS', city: 'Pelotas',
        payment_method: 'Pix, Débito, Crédito, Dinheiro',
        description: 'O melhor serviço de buffet do centro de Pelotas')
      event = Event.create!(buffet_id: buffet.id, name: 'Casamento',
        description: 'Buffets para casamentos',
        min_qtd: 50, max_qtd:1000, duration: 240, menu: 'Frutos do Mar',
        drinks: true, decoration: true, valet: true)
      customer = Customer.create!(email: 'cliente@email.com', password: 'password',
        name: 'cliente', cpf: '479.111.310-15')
      order = Order.new(buffet_id: buffet.id, event_id: event.id,
        event_date: Date.new(2039, 5, 1), estimated_qtd: 200,
        event_details: 'Esse evento deve possuir toda a temática com corações rosa',
        address: '', order_status: :waiting, final_price: nil, extra_tax: nil,
        discount: nil, customer_id: customer.id, out_doors: false, payment_final_date: Date.new(2024, 5, 1))
      result = order.valid?
      result = order.errors.include?(:payment_final_date)

      expect(result).to be true
      expect(order.errors[:payment_final_date]).to include(' deve ser futura')
    end

    it 'must have an estimated qtd' do
      buffet = Buffet.create!(name: 'Vini Gourmet',
        corporate_name: 'Vinícius Gourmet alimentos', 
        register_number: '12456456000145', phone: '53 991814646',
        email: 'vinigperuzzi@gourmet.com', address: 'Estrada do Laranjal, 695',
        district: 'Laranjal', state: 'RS', city: 'Pelotas',
        payment_method: 'Pix, Débito, Crédito, Dinheiro',
        description: 'O melhor serviço de buffet do centro de Pelotas')
      event = Event.create!(buffet_id: buffet.id, name: 'Casamento',
        description: 'Buffets para casamentos',
        min_qtd: 200, max_qtd:1000, duration: 240, menu: 'Frutos do Mar',
        drinks: true, decoration: true, valet: true)
      customer = Customer.create!(email: 'cliente@email.com', password: 'password',
        name: 'cliente', cpf: '479.111.310-15')
      order = Order.new(buffet_id: buffet.id, event_id: event.id,
        event_date: 1.day.from_now, estimated_qtd: nil,
        event_details: 'Esse evento deve possuir toda a temática com corações rosa',
        address: '', order_status: :waiting, final_price: nil, extra_tax: nil,
        discount: nil, customer_id: customer.id, out_doors: false)
      result = order.valid?
      result = order.errors.include?(:estimated_qtd)

      expect(result).to be true
      expect(order.errors[:estimated_qtd]).to include('não pode ficar em branco')
    end

    it 'and estimated qtd must be minor than event max qtd' do
      buffet = Buffet.create!(name: 'Vini Gourmet',
        corporate_name: 'Vinícius Gourmet alimentos', 
        register_number: '12456456000145', phone: '53 991814646',
        email: 'vinigperuzzi@gourmet.com', address: 'Estrada do Laranjal, 695',
        district: 'Laranjal', state: 'RS', city: 'Pelotas',
        payment_method: 'Pix, Débito, Crédito, Dinheiro',
        description: 'O melhor serviço de buffet do centro de Pelotas')
      event = Event.create!(buffet_id: buffet.id, name: 'Casamento',
        description: 'Buffets para casamentos',
        min_qtd: 500, max_qtd:1000, duration: 240, menu: 'Frutos do Mar',
        drinks: true, decoration: true, valet: true)
      customer = Customer.create!(email: 'cliente@email.com', password: 'password',
        name: 'cliente', cpf: '479.111.310-15')
      order = Order.new(buffet_id: buffet.id, event_id: event.id,
        event_date: 1.day.from_now, estimated_qtd: 5000,
        event_details: 'Esse evento deve possuir toda a temática com corações rosa',
        address: '', order_status: :waiting, final_price: nil, extra_tax: nil,
        discount: nil, customer_id: customer.id, out_doors: false)
      result = order.valid?
      result = order.errors.include?(:estimated_qtd)

      expect(result).to be true
      expect(order.errors[:estimated_qtd]).to include(' não pode ser maior do que a quantidade máxima do evento')
    end

    it 'must have an event details' do
      buffet = Buffet.create!(name: 'Vini Gourmet',
        corporate_name: 'Vinícius Gourmet alimentos', 
        register_number: '12456456000145', phone: '53 991814646',
        email: 'vinigperuzzi@gourmet.com', address: 'Estrada do Laranjal, 695',
        district: 'Laranjal', state: 'RS', city: 'Pelotas',
        payment_method: 'Pix, Débito, Crédito, Dinheiro',
        description: 'O melhor serviço de buffet do centro de Pelotas')
      event = Event.create!(buffet_id: buffet.id, name: 'Casamento',
        description: 'Buffets para casamentos',
        min_qtd: 50, max_qtd:1000, duration: 240, menu: 'Frutos do Mar',
        drinks: true, decoration: true, valet: true)
      customer = Customer.create!(email: 'cliente@email.com', password: 'password',
        name: 'cliente', cpf: '479.111.310-15')
      order = Order.new(buffet_id: buffet.id, event_id: event.id,
        event_date: 1.day.from_now, estimated_qtd: 200,
        event_details: nil,
        address: '', order_status: :waiting, final_price: nil, extra_tax: nil,
        discount: nil, customer_id: customer.id, out_doors: false)
      result = order.valid?
      result = order.errors.include?(:event_details)

      expect(result).to be true
      expect(order.errors[:event_details]).to include('não pode ficar em branco')
    end

    it 'must have a order status' do
      buffet = Buffet.create!(name: 'Vini Gourmet',
        corporate_name: 'Vinícius Gourmet alimentos', 
        register_number: '12456456000145', phone: '53 991814646',
        email: 'vinigperuzzi@gourmet.com', address: 'Estrada do Laranjal, 695',
        district: 'Laranjal', state: 'RS', city: 'Pelotas',
        payment_method: 'Pix, Débito, Crédito, Dinheiro',
        description: 'O melhor serviço de buffet do centro de Pelotas')
      event = Event.create!(buffet_id: buffet.id, name: 'Casamento',
        description: 'Buffets para casamentos',
        min_qtd: 50, max_qtd:1000, duration: 240, menu: 'Frutos do Mar',
        drinks: true, decoration: true, valet: true)
      customer = Customer.create!(email: 'cliente@email.com', password: 'password',
        name: 'cliente', cpf: '479.111.310-15')
      order = Order.new(buffet_id: buffet.id, event_id: event.id,
        event_date: 1.day.from_now, estimated_qtd: 200,
        event_details: 'Esse evento deve possuir toda a temática com corações rosa',
        address: '', order_status: nil, final_price: nil, extra_tax: nil,
        discount: nil, customer_id: customer.id, out_doors: false)
      result = order.valid?
      result = order.errors.include?(:order_status)

      expect(result).to be true
      expect(order.errors[:order_status]).to include('não pode ficar em branco')
    end

    it 'must have an unique code' do
      buffet = Buffet.create!(name: 'Vini Gourmet',
        corporate_name: 'Vinícius Gourmet alimentos', 
        register_number: '12456456000145', phone: '53 991814646',
        email: 'vinigperuzzi@gourmet.com', address: 'Estrada do Laranjal, 695',
        district: 'Laranjal', state: 'RS', city: 'Pelotas',
        payment_method: 'Pix, Débito, Crédito, Dinheiro',
        description: 'O melhor serviço de buffet do centro de Pelotas')
      event = Event.create!(buffet_id: buffet.id, name: 'Casamento',
        description: 'Buffets para casamentos',
        min_qtd: 50, max_qtd:1000, duration: 240, menu: 'Frutos do Mar',
        drinks: true, decoration: true, valet: true)
      customer = Customer.create!(email: 'cliente@email.com', password: 'password',
        name: 'cliente', cpf: '479.111.310-15')
      order = Order.new(buffet_id: buffet.id, event_id: event.id,
        event_date: 1.day.from_now, estimated_qtd: 200,
        event_details: 'Esse evento deve possuir toda a temática com corações rosa',
        address: '', order_status: :waiting, final_price: nil, extra_tax: nil,
        discount: nil, customer_id: customer.id, out_doors: false)
      result = order.valid?
      
      expect(order.code.length).to eq 8 
    end

    it 'and cannot edit unique code' do
      buffet = Buffet.create!(name: 'Vini Gourmet',
        corporate_name: 'Vinícius Gourmet alimentos', 
        register_number: '12456456000145', phone: '53 991814646',
        email: 'vinigperuzzi@gourmet.com', address: 'Estrada do Laranjal, 695',
        district: 'Laranjal', state: 'RS', city: 'Pelotas',
        payment_method: 'Pix, Débito, Crédito, Dinheiro',
        description: 'O melhor serviço de buffet do centro de Pelotas')
      event = Event.create!(buffet_id: buffet.id, name: 'Casamento',
        description: 'Buffets para casamentos',
        min_qtd: 50, max_qtd:1000, duration: 240, menu: 'Frutos do Mar',
        drinks: true, decoration: true, valet: true)
      customer = Customer.create!(email: 'cliente@email.com', password: 'password',
        name: 'cliente', cpf: '479.111.310-15')
      order = Order.create!(buffet_id: buffet.id, event_id: event.id,
        event_date: 1.day.from_now, estimated_qtd: 200,
        event_details: 'Esse evento deve possuir toda a temática com corações rosa',
        address: '', order_status: :waiting, final_price: nil, extra_tax: nil,
        discount: nil, customer_id: customer.id, out_doors: false)
      first_code = order.code
      order.update(estimated_qtd: 300)
      
      expect(order.code).to eq first_code
    end
  end
end
