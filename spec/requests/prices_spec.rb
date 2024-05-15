require "rails_helper"

describe 'User try to request actions in prices' do
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

      post event_prices_path(event_id: event.id), params: {price: {base_price: 5000,
        additional_person: 250, extra_hour: 100, sp_base_price: 6000,
        sp_additional_person: 350, sp_extra_hour: 150}}
      
      expect(response).to redirect_to(new_user_session_path)
    end

    it 'and are authenticated as customer' do
      user = User.create!(email: 'vinicius@email.com', password: 'password')
      buffet = Buffet.create!(name: 'Vini', corporate_name: 'Vinícius Gourmet alimentos', 
        register_number: '12456456000145', phone: '53 991814646',
        email: 'vinigperuzzi@gourmet.com', address: 'Estrada do Laranjal, 695',
        district: 'Laranjal', state: 'RS', city: 'Pelotas',
        payment_method: 'Pix, Débito, Crédito, Dinheiro',
        description: 'O melhor serviço de buffet do centro de Pelotas')
      user.update!(buffet_id: buffet.id)
      customer = Customer.create!(email: 'cliente@email.com', password: 'password',
        name: 'cliente', cpf: '479.111.310-15')
      event = Event.create!(name: 'Casamento',
        description: 'Serviço de mesa completo para casamentos',
        min_qtd: 20, max_qtd: 40, duration: 250, menu: 'Frutos do Mar',
        buffet_id: buffet.id)

      login_as customer, scope: :customer
      post event_prices_path(event_id: event.id), params: {price: {base_price: 5000,
        additional_person: 250, extra_hour: 100, sp_base_price: 6000,
        sp_additional_person: 350, sp_extra_hour: 150}}
      
      expect(response).to redirect_to(new_user_session_path)
    end
  end

  context '#update' do
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
      price = Price.create!(base_price: 5000, sp_base_price:6000,
        sp_additional_person:500, additional_person:200, sp_extra_hour:30,
        extra_hour:20, event_id: event.id)

      patch event_price_path(event_id: event.id, id: price.id), params: {price: {base_price: 5000,
        additional_person: 250, extra_hour: 100, sp_base_price: 6000,
        sp_additional_person: 350, sp_extra_hour: 150}}
      
      expect(response).to redirect_to(new_user_session_path)
    end

    it 'and are authenticated as customer' do
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


      login_as customer, scope: :customer
      patch event_price_path(event_id: event.id, id: price.id), params: {price: {base_price: 5000,
        additional_person: 250, extra_hour: 100, sp_base_price: 6000,
        sp_additional_person: 350, sp_extra_hour: 150}}
      
      expect(response).to redirect_to(new_user_session_path)
    end

    it "and are authenticated as owner, but tries to update other's buffet's event's prices" do
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

      user2 = User.create!(email: 'debora@email.com', password: 'password2')


      login_as user2, scope: :user
      patch event_price_path(event_id: event.id, id: price.id), params: {price: {base_price: 5000,
        additional_person: 250, extra_hour: 100, sp_base_price: 6000,
        sp_additional_person: 350, sp_extra_hour: 150}}
      
      expect(response).to redirect_to(root_path)
    end
  end
end