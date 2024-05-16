require "rails_helper"

describe 'User try to request actions in buffet' do
  context '#create' do
    it 'and are not authenticated' do
      post buffets_path, params: {buffet: {name: 'teste', corporate_name: 'teste',
        register_number: 'teste', phone: 'teste', email: 'teste@teste.com',
        address: 'teste', district: 'teste',
        state: 'teste', city: 'teste', payment_method: 'teste',
        description: 'teste'}}
      
      expect(response).to redirect_to(new_user_session_path)
    end

    it 'and are authenticated as customer' do
      customer = Customer.create!(email: 'cliente@email.com', password: 'password',
        name: 'cliente', cpf: '479.111.310-15')

      login_as customer, scope: :customer
      post buffets_path, params: {buffet: {name: 'teste', corporate_name: 'teste',
        register_number: 'teste', phone: 'teste', email: 'teste@teste.com',
        address: 'teste', district: 'teste',
        state: 'teste', city: 'teste', payment_method: 'teste',
        description: 'teste'}}
      
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

      patch buffet_path(buffet.id), params: {buffet: {name: 'teste', corporate_name: 'teste',
        register_number: 'teste', phone: 'teste', email: 'teste@teste.com',
        address: 'teste', district: 'teste',
        state: 'teste', city: 'teste', payment_method: 'teste',
        description: 'teste'}}
      
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

      login_as customer, scope: :customer
      patch buffet_path(buffet.id), params: {buffet: {name: 'teste',
        corporate_name: 'teste', register_number: 'teste',
        phone: 'teste', email: 'teste@teste.com',
        address: 'teste', district: 'teste',
        state: 'teste', city: 'teste', payment_method: 'teste',
        description: 'teste'}}
      
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
      user2 = User.create!(email: 'debora@email.com', password: 'password2')

      login_as user, scope: :user2
      patch buffet_path(buffet.id), params: {buffet: {name: 'teste',
        corporate_name: 'teste', register_number: 'teste',
        phone: 'teste', email: 'teste@teste.com',
        address: 'teste', district: 'teste',
        state: 'teste', city: 'teste', payment_method: 'teste',
        description: 'teste'}}
      
      expect(response).to redirect_to(new_user_session_path)
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

      get active_buffet_path(buffet.id)

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
      customer = Customer.create!(email: 'cliente@email.com', password: 'password',
        name: 'cliente', cpf: '479.111.310-15')

      login_as customer, scope: :customer
      get active_buffet_path(buffet.id)

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
      user.update!(buffet_id: buffet.id)
      user2 = User.create!(email: 'debora@email.com', password: 'password2')
      buffet2 = Buffet.create!(name: 'Dé Licias', corporate_name: 'Débora Doces e tortas', 
        register_number: '12412356000145', phone: '53 991549865',
        email: 'debora@email.com', address: 'Santos Dumont, 695',
        district: 'Centro', state: 'RS', city: 'Piratini',
        payment_method: 'Dinheiro',
        description: 'Doces e tortas para alegrara sua vida')
      user2.update!(buffet_id: buffet2.id)

      login_as user, scope: :user
      get active_buffet_path(buffet2.id)

      expect(response).to redirect_to(buffet_path(buffet.id))
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

      get inactive_buffet_path(buffet.id)

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
      customer = Customer.create!(email: 'cliente@email.com', password: 'password',
        name: 'cliente', cpf: '479.111.310-15')

      login_as customer, scope: :customer
      get inactive_buffet_path(buffet.id)

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
      user2 = User.create!(email: 'debora@email.com', password: 'password2')
      buffet2 = Buffet.create!(name: 'Dé Licias', corporate_name: 'Débora Doces e tortas', 
        register_number: '12412356000145', phone: '53 991549865',
        email: 'debora@email.com', address: 'Santos Dumont, 695',
        district: 'Centro', state: 'RS', city: 'Piratini',
        payment_method: 'Dinheiro',
        description: 'Doces e tortas para alegrara sua vida')
      user2.update!(buffet_id: buffet2.id)

      login_as user, scope: :user
      get inactive_buffet_path(buffet2.id)

      expect(response).to redirect_to(buffet_path(buffet.id))
    end
  end
end