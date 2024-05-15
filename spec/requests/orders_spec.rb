require "rails_helper"

describe 'User try to request actions in orders' do
  context '#create' do
    it 'and are not authenticated' do
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
      customer = Customer.create!(email: 'cliente@email.com', password: 'password',
        name: 'cliente', cpf: '479.111.310-15')

      post event_orders_path(event_id: event.id), params: {order: {
        buffet_id: buffet.id, event_id: event.id,
        event_date: Date.new(2134, 5, 1), estimated_qtd: 30,
        event_details: 'Esse evento deve possuir toda a temática com corações rosa',
        address: '', order_status: :waiting, final_price: 11000, extra_tax: 1000,
        discount: 500, customer_id: customer.id, out_doors: false}}
      
      expect(response).to redirect_to(new_customer_session_path)
    end
  end

  context '#confirm' do
    it 'and are not authenticated' do
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
      customer = Customer.create!(email: 'cliente@email.com', password: 'password',
        name: 'cliente', cpf: '479.111.310-15')
      order = Order.create!(buffet_id: buffet.id, event_id: event.id,
        event_date: Date.new(2134, 5, 1), estimated_qtd: 30,
        event_details: 'Esse evento deve possuir toda a temática com corações rosa',
        address: '', order_status: :waiting, final_price: 11000, extra_tax: 1000,
        discount: 500, customer_id: customer.id, out_doors: false)

      get confirm_order_path(order.id)
      
      expect(response).to redirect_to(new_user_session_path)
    end

    it "and are authenticated as owner, but tries to confirm other's event's orders" do
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
      customer = Customer.create!(email: 'cliente@email.com', password: 'password',
        name: 'cliente', cpf: '479.111.310-15')
      order = Order.create!(buffet_id: buffet.id, event_id: event.id,
        event_date: Date.new(2134, 5, 1), estimated_qtd: 30,
        event_details: 'Esse evento deve possuir toda a temática com corações rosa',
        address: '', order_status: :waiting, final_price: 11000, extra_tax: 1000,
        discount: 500, customer_id: customer.id, out_doors: false)
      user2 = User.create!(email: 'debora@email.com', password: 'password2')

      login_as user2, scope: :user
      get confirm_order_path(order.id)
      
      expect(response).to redirect_to(new_user_session_path)
    end

    it "and are authenticated as customer, but tries to confirm other's event's orders" do
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
      customer = Customer.create!(email: 'cliente@email.com', password: 'password',
        name: 'cliente', cpf: '479.111.310-15')
      order = Order.create!(buffet_id: buffet.id, event_id: event.id,
        event_date: Date.new(2134, 5, 1), estimated_qtd: 30,
        event_details: 'Esse evento deve possuir toda a temática com corações rosa',
        address: '', order_status: :waiting, final_price: 11000, extra_tax: 1000,
        discount: 500, customer_id: customer.id, out_doors: false)
      customer2 = Customer.create!(email: 'cliente2@email.com', password: 'password2',
        name: 'cliente2', cpf: '325.066.805-27')

      login_as customer2, scope: :customer
      get confirm_order_path(order.id)
      
      expect(response).to redirect_to(new_customer_session_path)
    end
  end

  context '#cancel' do
    it 'and are not authenticated' do
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
      customer = Customer.create!(email: 'cliente@email.com', password: 'password',
        name: 'cliente', cpf: '479.111.310-15')
      order = Order.create!(buffet_id: buffet.id, event_id: event.id,
        event_date: Date.new(2134, 5, 1), estimated_qtd: 30,
        event_details: 'Esse evento deve possuir toda a temática com corações rosa',
        address: '', order_status: :waiting, final_price: 11000, extra_tax: 1000,
        discount: 500, customer_id: customer.id, out_doors: false)

      get cancel_order_path(order.id)
      
      expect(response).to redirect_to(new_user_session_path)
    end

    it "and are authenticated as owner, but tries to confirm other's event's orders" do
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
      customer = Customer.create!(email: 'cliente@email.com', password: 'password',
        name: 'cliente', cpf: '479.111.310-15')
      order = Order.create!(buffet_id: buffet.id, event_id: event.id,
        event_date: Date.new(2134, 5, 1), estimated_qtd: 30,
        event_details: 'Esse evento deve possuir toda a temática com corações rosa',
        address: '', order_status: :waiting, final_price: 11000, extra_tax: 1000,
        discount: 500, customer_id: customer.id, out_doors: false)
      user2 = User.create!(email: 'debora@email.com', password: 'password2')

      login_as user2, scope: :user
      get cancel_order_path(order.id)
      
      expect(response).to redirect_to(new_user_session_path)
    end

    it "and are authenticated as customer, but tries to confirm other's event's orders" do
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
      customer = Customer.create!(email: 'cliente@email.com', password: 'password',
        name: 'cliente', cpf: '479.111.310-15')
      order = Order.create!(buffet_id: buffet.id, event_id: event.id,
        event_date: Date.new(2134, 5, 1), estimated_qtd: 30,
        event_details: 'Esse evento deve possuir toda a temática com corações rosa',
        address: '', order_status: :waiting, final_price: 11000, extra_tax: 1000,
        discount: 500, customer_id: customer.id, out_doors: false)
      customer2 = Customer.create!(email: 'cliente2@email.com', password: 'password2',
        name: 'cliente2', cpf: '325.066.805-27')

      login_as customer2, scope: :customer
      get cancel_order_path(order.id)
      
      expect(response).to redirect_to(new_customer_session_path)
    end
  end
end