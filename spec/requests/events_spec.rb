require "rails_helper"

describe 'User try to request actions in event' do
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

      post events_path, params: {event: {name: 'teste', description:'teste',
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
      post events_path, params: {event: {name: 'teste', description:'teste',
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

      patch event_path(event.id), params: {event: {name: 'teste', description:'teste',
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
      patch event_path(event.id), params: {event: {name: 'teste', description:'teste',
        min_qtd: 10, max_qtd: 200, duration: 320, menu: 'teste',
        drinks: true, decoration: true, valet: true, only_local: false}}
      
      expect(response).to redirect_to(new_user_session_path)
    end

    it "and are authenticated as owner, but tries to update other's buffet's event" do
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
      patch event_path(event.id), params: {event: {name: 'teste', description:'teste',
        min_qtd: 10, max_qtd: 200, duration: 320, menu: 'teste',
        drinks: true, decoration: true, valet: true, only_local: false}}
      
      expect(response).to redirect_to(root_path)
    end
  end

  context '#delete' do
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

      delete event_path(event.id)
      
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
      delete event_path(event.id)
      
      expect(response).to redirect_to(new_user_session_path)
    end

    it "and are authenticated as owner, but tries to delete other's buffet's event" do
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
      delete event_path(event.id)
      
      expect(response).to redirect_to(root_path)
    end
  end

  context '#active' do
    it 'and are not authenticated' do
      user = User.create!(email: 'vinicius@email.com', password: 'password')
      buffet = Buffet.create!(name: 'Vini', corporate_name: 'Vinícius Gourmet alimentos', 
        register_number: '12456456000145', phone: '53 991814646',
        email: 'vinigperuzzi@gourmet.com', address: 'Estrada do Laranjal, 695',
        district: 'Laranjal', state: 'RS', city: 'Pelotas',
        payment_method: 'Pix, Débito, Crédito, Dinheiro',
        description: 'O melhor serviço de buffet do centro de Pelotas', active: false)
      user.update!(buffet_id: buffet.id)
      event1 = Event.create!(name: 'Casamento',
        description: 'Serviço de mesa completo para casamentos',
        min_qtd: 20, max_qtd: 40, duration: 250, menu: 'Frutos do Mar',
        buffet_id: buffet.id, active: false)
      

      post active_event_path(event1.id)

      expect(response).to redirect_to(new_user_session_path)
    end

    it 'and are authenticated as customer' do
      user = User.create!(email: 'vinicius@email.com', password: 'password')
      buffet = Buffet.create!(name: 'Vini', corporate_name: 'Vinícius Gourmet alimentos', 
        register_number: '12456456000145', phone: '53 991814646',
        email: 'vinigperuzzi@gourmet.com', address: 'Estrada do Laranjal, 695',
        district: 'Laranjal', state: 'RS', city: 'Pelotas',
        payment_method: 'Pix, Débito, Crédito, Dinheiro',
        description: 'O melhor serviço de buffet do centro de Pelotas', active: false)
      user.update!(buffet_id: buffet.id)
      event1 = Event.create!(name: 'Casamento',
        description: 'Serviço de mesa completo para casamentos',
        min_qtd: 20, max_qtd: 40, duration: 250, menu: 'Frutos do Mar',
        buffet_id: buffet.id, active: false)
      customer = Customer.create!(email: 'cliente@email.com', password: 'password',
        name: 'cliente', cpf: '479.111.310-15')

      login_as customer, scope: :customer
      post active_event_path(event1.id)

      expect(response).to redirect_to(new_user_session_path)

    end

    it "and are authenticated as owner, but tries to active other's buffet" do
      user = User.create!(email: 'vinicius@email.com', password: 'password')
      buffet = Buffet.create!(name: 'Vini', corporate_name: 'Vinícius Gourmet alimentos', 
        register_number: '12456456000145', phone: '53 991814646',
        email: 'vinigperuzzi@gourmet.com', address: 'Estrada do Laranjal, 695',
        district: 'Laranjal', state: 'RS', city: 'Pelotas',
        payment_method: 'Pix, Débito, Crédito, Dinheiro',
        description: 'O melhor serviço de buffet do centro de Pelotas', active: false)
      event1 = Event.create!(name: 'Casamento',
        description: 'Serviço de mesa completo para casamentos',
        min_qtd: 20, max_qtd: 40, duration: 250, menu: 'Frutos do Mar',
        buffet_id: buffet.id, active: false)
      user.update!(buffet_id: buffet.id)
      user2 = User.create!(email: 'debora@email.com', password: 'password2')
      buffet2 = Buffet.create!(name: 'Dé Licias', corporate_name: 'Débora Doces e tortas', 
        register_number: '12412356000145', phone: '53 991549865',
        email: 'debora@email.com', address: 'Santos Dumont, 695',
        district: 'Centro', state: 'RS', city: 'Piratini',
        payment_method: 'Dinheiro',
        description: 'Doces e tortas para alegrara sua vida')
      user2.update!(buffet_id: buffet2.id)

      login_as user2, scope: :user
      post active_event_path(event1.id)

      expect(response).to redirect_to(root_path)
    end
  end

  context '#inactive' do
    it 'and are not authenticated' do
      user = User.create!(email: 'vinicius@email.com', password: 'password')
      buffet = Buffet.create!(name: 'Vini', corporate_name: 'Vinícius Gourmet alimentos', 
        register_number: '12456456000145', phone: '53 991814646',
        email: 'vinigperuzzi@gourmet.com', address: 'Estrada do Laranjal, 695',
        district: 'Laranjal', state: 'RS', city: 'Pelotas',
        payment_method: 'Pix, Débito, Crédito, Dinheiro',
        description: 'O melhor serviço de buffet do centro de Pelotas', active: false)
      user.update!(buffet_id: buffet.id)
      event1 = Event.create!(name: 'Casamento',
        description: 'Serviço de mesa completo para casamentos',
        min_qtd: 20, max_qtd: 40, duration: 250, menu: 'Frutos do Mar',
        buffet_id: buffet.id, active: false)

      post active_event_path(event1.id)

      expect(response).to redirect_to(new_user_session_path)
    end

    it 'and are authenticated as customer' do
      user = User.create!(email: 'vinicius@email.com', password: 'password')
      buffet = Buffet.create!(name: 'Vini', corporate_name: 'Vinícius Gourmet alimentos', 
        register_number: '12456456000145', phone: '53 991814646',
        email: 'vinigperuzzi@gourmet.com', address: 'Estrada do Laranjal, 695',
        district: 'Laranjal', state: 'RS', city: 'Pelotas',
        payment_method: 'Pix, Débito, Crédito, Dinheiro',
        description: 'O melhor serviço de buffet do centro de Pelotas', active: false)
      user.update!(buffet_id: buffet.id)
      event1 = Event.create!(name: 'Casamento',
        description: 'Serviço de mesa completo para casamentos',
        min_qtd: 20, max_qtd: 40, duration: 250, menu: 'Frutos do Mar',
        buffet_id: buffet.id, active: false)
      customer = Customer.create!(email: 'cliente@email.com', password: 'password',
        name: 'cliente', cpf: '479.111.310-15')

      login_as customer, scope: :customer
      post active_event_path(event1.id)

      expect(response).to redirect_to(new_user_session_path)

    end

    it "and are authenticated as owner, but tries to inactive other's buffet" do
      user = User.create!(email: 'vinicius@email.com', password: 'password')
      buffet = Buffet.create!(name: 'Vini', corporate_name: 'Vinícius Gourmet alimentos', 
        register_number: '12456456000145', phone: '53 991814646',
        email: 'vinigperuzzi@gourmet.com', address: 'Estrada do Laranjal, 695',
        district: 'Laranjal', state: 'RS', city: 'Pelotas',
        payment_method: 'Pix, Débito, Crédito, Dinheiro',
        description: 'O melhor serviço de buffet do centro de Pelotas', active: false)
      user.update!(buffet_id: buffet.id)
      event1 = Event.create!(name: 'Casamento',
        description: 'Serviço de mesa completo para casamentos',
        min_qtd: 20, max_qtd: 40, duration: 250, menu: 'Frutos do Mar',
        buffet_id: buffet.id, active: false)
      user2 = User.create!(email: 'debora@email.com', password: 'password2')
      buffet2 = Buffet.create!(name: 'Dé Licias', corporate_name: 'Débora Doces e tortas', 
        register_number: '12412356000145', phone: '53 991549865',
        email: 'debora@email.com', address: 'Santos Dumont, 695',
        district: 'Centro', state: 'RS', city: 'Piratini',
        payment_method: 'Dinheiro',
        description: 'Doces e tortas para alegrara sua vida')
      user2.update!(buffet_id: buffet2.id)

      login_as user2, scope: :user
      post active_event_path(event1.id)

      expect(response).to redirect_to(root_path)
    end
  end
end