require "rails_helper"

describe 'User try to request actions in buffet' do
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

      post events_path, params: {buffet: {name: 'teste', description:'teste',
        min_qtd: 10, max_qtd: 200, duration: 320, menu: 'teste',
        drinks: true, decoration: true, valet: true, only_local: false}}
      
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

      login_as customer, scope: :customer
      post events_path, params: {buffet: {name: 'teste', description:'teste',
        min_qtd: 10, max_qtd: 200, duration: 320, menu: 'teste',
        drinks: true, decoration: true, valet: true, only_local: false}}
      
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

      patch event_path(event.id), params: {buffet: {name: 'teste', description:'teste',
        min_qtd: 10, max_qtd: 200, duration: 320, menu: 'teste',
        drinks: true, decoration: true, valet: true, only_local: false}}
      
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

      login_as customer, scope: :customer
      patch event_path(event.id), params: {buffet: {name: 'teste', description:'teste',
        min_qtd: 10, max_qtd: 200, duration: 320, menu: 'teste',
        drinks: true, decoration: true, valet: true, only_local: false}}
      
      expect(response).to redirect_to(new_user_session_path)
    end

    it "and are authenticated as owner, but tries to update other's buffet" do
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
      user2 = User.create!(email: 'debora@email.com', password: 'password2')


      login_as user2, scope: :user
      patch event_path(event.id), params: {buffet: {name: 'teste', description:'teste',
        min_qtd: 10, max_qtd: 200, duration: 320, menu: 'teste',
        drinks: true, decoration: true, valet: true, only_local: false}}
      
      expect(response).to redirect_to(root_path)
    end
  end
end